//
//  ImagesListService.swift
//  ImageFeedApp
//
//  Created by Данил on 23/10/2026.
//

import Foundation

final class ImagesListService {
  static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
  
  private(set) var photos: [Photo] = []
  private var lastLoadedPage: Int?
  
  private let networkClient: NetworkRouting
  private let storage: OAuth2TokenStorage = .init()
  
  init(networkClient: NetworkRouting = NetworkClient()) {
    self.networkClient = networkClient
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
              let photo = Photo(result:item)
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
}
