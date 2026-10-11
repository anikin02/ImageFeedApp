//
//  Untitled.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//
import Foundation

protocol NetworkRouting {
  func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
  private static let happyStatusCodes = 200..<300
  
  func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error {
        handler(.failure(error))
        return
      }
      
      if let response = response as? HTTPURLResponse,
         !Self.happyStatusCodes.contains(response.statusCode) {
        handler(.failure(NetworkError.codeError))
        return
      }
      
      guard let data else {
        handler(.failure(NetworkError.noData))
        return
      }
      handler(.success(data))
    }
    
    task.resume()
  }
}

enum NetworkError: Error {
  case codeError
  case noData
}
