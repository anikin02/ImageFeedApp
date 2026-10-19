//
//  ProfileImageService.swift
//  ImageFeedApp
//
//  Created by Данил on 14/10/2026.
//
import Foundation

final class ProfileImageService {
  static let shared = ProfileImageService()
  static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
  
  private(set) var profileImage: ProfileImage?
  
  private let networkClient: NetworkRouting
  
  private let storage: OAuth2TokenStorage = .init()
  
  private enum NetworkError: Error {
    case badRequest
    case tokenError
  }
  
  private init(networkClient: NetworkRouting = NetworkClient() ) {
    self.networkClient = networkClient
  }
  
  func fetchProfileImageURL(_ username: String, completion: @escaping (Result<ProfileImage, Error>) -> Void) {
    assert(Thread.isMainThread)
    if networkClient.oldTask != nil {
      networkClient.oldTask?.cancel()
    }
    
    guard let token = storage.token else {
      completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
      return
    }
    
    guard let request = makeProfileImageRequest(username: username, token: token) else {
      return completion(.failure(NetworkError.badRequest))
    }
    
    networkClient.fetch(request: request) { (result: Result<UserResult, Error>) in
      DispatchQueue.main.async {
        switch result {
          case .success(let image):
            self.profileImage = image.profile_image
            completion(.success(image.profile_image))
            NotificationCenter.default
              .post(
                name: ProfileImageService.didChangeNotification,
                object: self,
                userInfo: ["URL": image.profile_image.small])
          case .failure(let error):
            print(error.localizedDescription)
            completion(.failure(error))
        }
      }
    }
  }
  
  private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
    guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.get.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    print(request)
    return request
  }
}

