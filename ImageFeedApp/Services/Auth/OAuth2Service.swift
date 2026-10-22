//
//  OAuth2Service.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//
import Foundation

final class OAuth2Service {
  static let shared = OAuth2Service()
  
  private var lastCode: String?
  
  private let urlTokenString: String = "https://unsplash.com/oauth/token"
  private let networkClient: NetworkRouting
  
  private enum NetworkError: Error {
    case badRequest
    case codeError
  }
  
  private init(networkClient: NetworkRouting = NetworkClient() ) {
    self.networkClient = networkClient
  }
  
  func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
    assert(Thread.isMainThread)
    if networkClient.oldTask != nil {
      if lastCode != code {
        networkClient.oldTask?.cancel()
      } else {
        print("[fetchOAuthToken]: oldTask != nil, lastCode = code")
        completion(.failure(NetworkError.badRequest))
        return
      }
    } else {
      if lastCode == code {
        print("[fetchOAuthToken]: lastCode = code")
        completion(.failure(NetworkError.badRequest))
        return
      }
    }
    
    lastCode = code
    
    guard let request = makeOAuthTokenRequest(code: code) else {
      return completion(.failure(NetworkError.badRequest))
    }
    
    networkClient.fetch(request: request) { (result: Result<OAuthTokenResponseBody, Error>) in
      DispatchQueue.main.async {
        self.lastCode = nil
        switch result {
          case .success(let token):
            completion(.success(token.access_token))
          case .failure(let error):
            print(error.localizedDescription)
            completion(.failure(error))
        }
      }
    }
  }
  
  private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    guard
      var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
    else {
      assertionFailure("Failed to create URL")
      return nil
    }
    
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.accessKey),
      URLQueryItem(name: "client_secret", value: Constants.secretKey),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
      URLQueryItem(name: "code", value: code),
      URLQueryItem(name: "grant_type", value: "authorization_code"),
    ]
    
    guard let authTokenUrl = urlComponents.url else {
      return nil
    }
    
    var request = URLRequest(url: authTokenUrl)
    request.httpMethod = HTTPMethod.post.rawValue
    return request
  }
}
