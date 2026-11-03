//
//  ProfileViewControllerSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 29/10/2026.
//

@testable import ImageFeedApp
import Foundation

final class ProfileViewControllerSpy: ProfileViewProtocol  {
  var presenter: ProfilePresenterProtocol?
  var showAlertCalled: Bool = false
  var switchToSplashViewControllerCalled: Bool = false
  var showProfileCalled: Bool = false
  var showAvatarCalled: Bool = false
  
  func showProfile(profile: ImageFeedApp.Profile) {
    showProfileCalled = true
  }
  
  func showAvatar(url: URL) {
    showAvatarCalled = true
  }
  
  func showAlertExitWarning() {
    showAlertCalled = true
  }
  
  func switchToSplashViewController() {
    switchToSplashViewControllerCalled = true
  }
}
