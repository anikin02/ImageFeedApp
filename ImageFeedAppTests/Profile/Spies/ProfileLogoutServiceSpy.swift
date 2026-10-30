//
//  ProfileLogoutServiceSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 29/10/2026.
//

@testable import ImageFeedApp
import Foundation

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
  var logoutCalled: Bool = false
  
  func logout() {
    logoutCalled = true
  }
}
