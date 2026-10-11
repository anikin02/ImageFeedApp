//
//  OAuth2Service.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//
import Foundation

final class OAuth2Service {
  static let shared = OAuth2Service()
  
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
    guard let request = makeOAuthTokenRequest(code: code) else {
      return completion(.failure(NetworkError.badRequest))
    }
    
    networkClient.fetch(request: request) { result in
      DispatchQueue.main.async {
        switch result {
          case .success(let data):
            do {
              let token = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
              completion(.success(token.access_token))
            }
            catch {
              print(error.localizedDescription)
              completion(.failure(error))
            }
          case .failure(let error):
            print(error.localizedDescription)
            completion(.failure(error))
        }
      }
    }
  }
  
  private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    guard var urlComponents = URLComponents(string: urlTokenString) else {
      print("Failed to create URLComponents")
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
      print("Failed to create URL")
      return nil
    }
    
    var request = URLRequest(url: authTokenUrl)
    request.httpMethod = "POST"
    return request
  }
}
