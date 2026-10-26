//
//  ProfileService.swift
//  ImageFeedApp
//
//  Created by Данил on 12/10/2026.
//
import Foundation

final class ProfileService {
  static let shared = ProfileService()
  private(set) var profile: Profile?
  
  private var lastCode: String?
  
  private let urlTokenString: String = "https://unsplash.com/oauth/token"
  private let networkClient: NetworkRouting
  
  private enum NetworkError: Error {
    case badRequest
    case tokenError
  }
  
  private init(networkClient: NetworkRouting = NetworkClient() ) {
    self.networkClient = networkClient
  }
  
  func logout() {
    profile = nil
    lastCode = nil
  }
  
  func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
    assert(Thread.isMainThread)
    if networkClient.oldTask != nil {
      networkClient.oldTask?.cancel()
    }
    
    guard let request = makeProfileRequest(token: token) else {
      return completion(.failure(NetworkError.badRequest))
    }
    
    networkClient.fetch(request: request) { (result: Result<ProfileResult, Error>) in
      DispatchQueue.main.async {
        self.lastCode = nil
        switch result {
          case .success(let profileResult):
            let profile = Profile(from: profileResult)
            self.profile = profile
            completion(.success(profile))
          case .failure(let error):
            print("[ProfileService: fetchProfile]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
            completion(.failure(error))
        }
      }
    }
  }
  
  private func makeProfileRequest(token: String) -> URLRequest? {
    guard let url = URL(string: "https://api.unsplash.com/me") else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.get.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }
}
