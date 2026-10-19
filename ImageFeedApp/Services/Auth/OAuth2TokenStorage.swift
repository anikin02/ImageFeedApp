//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
  private let tokenKey: String = "token"
  private let storage: KeychainWrapper = KeychainWrapper.standard
}

extension OAuth2TokenStorage {
  var token: String? {
    get {
      storage.string(forKey: tokenKey)
    }
    set {
      if let newValue {
        storage.set(newValue, forKey: tokenKey)
      }
    }
  }
}
