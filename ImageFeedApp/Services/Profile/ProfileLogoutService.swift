//
//  ProfileLogoutService.swift
//  ImageFeedApp
//
//  Created by Данил on 25/10/2026.
//

import Foundation
import WebKit

final class ProfileLogoutService {
  static let shared = ProfileLogoutService()
  private init() { }
  
  func logout() {
    OAuth2TokenStorage.shared.token = nil
    ProfileImageService.shared.logout()
    ProfileService.shared.logout()
    ImagesListService.shared.logout()
    
    cleanCookies()
  }
  
  private func cleanCookies() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }
}
