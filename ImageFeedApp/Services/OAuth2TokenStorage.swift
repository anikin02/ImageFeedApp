//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//

import Foundation

final class OAuth2TokenStorage {
  private let storage: UserDefaults = .standard
  private let tokenKey: String = "token"
}

extension OAuth2TokenStorage {
  var token: String? {
    get {
      storage.string(forKey: tokenKey)
    }
    set {
      storage.set(newValue, forKey: tokenKey)
    }
  }
}
