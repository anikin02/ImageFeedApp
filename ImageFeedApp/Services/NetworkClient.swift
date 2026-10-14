//
//  Untitled.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//
import Foundation

protocol NetworkRouting {
  var oldTask: URLSessionTask? { get set }
  func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkClient: NetworkRouting {
  var oldTask: URLSessionTask?
  private static let happyStatusCodes = 200..<300
  
  func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      
      self?.oldTask = nil
      
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
    
    oldTask = task
    task.resume()
  }
}

enum NetworkError: Error {
  case codeError
  case noData
}
