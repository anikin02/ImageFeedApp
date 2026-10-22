//
//  Untitled.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//
import Foundation

protocol NetworkRouting {
  var oldTask: URLSessionTask? { get set }
  func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkClient: NetworkRouting {
  var oldTask: URLSessionTask?
  private static let happyStatusCodes = 200..<300
  
  func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
    fetch(request: request) { result in
      switch result {
        case .success(let data):
          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
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
  
  private func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      
      self?.oldTask = nil
      
      if let error {
        print("[dataTask]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
        handler(.failure(error))
        return
      }
      
      if let response = response as? HTTPURLResponse,
         !Self.happyStatusCodes.contains(response.statusCode) {
        let error = NetworkError.codeError(response.statusCode)
        print("[dataTask]: NetworkError - код ошибки \(response.statusCode)")
        handler(.failure(error))
        return
      }
      
      guard let data else {
        let error = NetworkError.noData
        print("[loadAuthView]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
        handler(.failure(NetworkError.noData))
        return
      }
      
      handler(.success(data))
    }
    
    oldTask = task
    task.resume()
  }
}

enum NetworkError: Error, LocalizedError {
  case codeError(Int)
  case noData
  case invalidResponse

  var errorDescription: String? {
    switch self {
    case .codeError(let statusCode):
      return "код ошибки \(statusCode)"
    case .noData:
      return "ответ сервера не содержит данных"
    case .invalidResponse:
      return "ответ сервера не является HTTPURLResponse"
    }
  }
}
