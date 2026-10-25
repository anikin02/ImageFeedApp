//
//  ImagesListService.swift
//  ImageFeedApp
//
//  Created by Данил on 23/10/2026.
//

import Foundation

final class ImagesListService {
  static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
  static let shared = ImagesListService()
  
  private(set) var photos: [Photo] = []
  private var lastLoadedPage: Int?
  
  private let networkClient: NetworkRouting
  private let storage: OAuth2TokenStorage = .shared
  
  private init(networkClient: NetworkRouting = NetworkClient()) {
    self.networkClient = networkClient
  }
  
  func logout() {
    photos = []
    lastLoadedPage = nil
  }
  
  func fetchPhotosNextPage() {
    guard networkClient.oldTask == nil else {
      print("[ImagesListService: fetchPhotosNextPage]: запрос уже выполняется")
      return
    }
    
    guard let request = makeImagePageRequest(pageNumber: (lastLoadedPage ?? 0) + 1) else {
      print("[ImagesListService: fetchPhotosNextPage]: ошибка при создании request")
      return
    }
    networkClient.fetch(request: request) { [weak self] (result: Result<[PhotoResult], Error>) in
      DispatchQueue.main.async {
        guard let self else { return }
        switch result {
          case .success(let result):
            for item in result {
              let photo = Photo(result: item)
              self.photos.append(photo)
            }
            NotificationCenter.default
              .post(
                name: ImagesListService.didChangeNotification,
                object: self)
          case .failure(let error):
            print("[ImagesListService: fetchPhotosNextPage]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
        }
      }
    }
  }
  
  func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
    guard let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike) else {
      print("[ImagesListService: changeLike]: ошибка при создании request")
      return
    }
    
    networkClient.fetch(request: request) {(result: Result<LikeResponseResult, Error>) in
      DispatchQueue.main.async {
        switch result {
          case .success(let result):
            if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
              self.photos[index] = Photo(result: result.photo)
            }
            completion(.success(()))
          case .failure(let error):
            print("[ImagesListService: changeLike]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
        }
      }
    }
  }
  
  
  private func makeImagePageRequest(pageNumber: Int) -> URLRequest? {
    guard let url = URL(string: "https://api.unsplash.com/photos?page=\(pageNumber)&per_page=10") else {
      return nil
    }
    lastLoadedPage = pageNumber
    
    guard let token = storage.token else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.get.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    return request
  }
  
  private func makeChangeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
    guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
      return nil
    }
    
    guard let token = storage.token else { return nil }
    
    var request = URLRequest(url: url)
    if isLike {
      request.httpMethod = HTTPMethod.post.rawValue
    } else {
      request.httpMethod = HTTPMethod.delete.rawValue
    }
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    return request
  }
}
