//
//  ProfilePresenter.swift
//  ImageFeedApp
//
//  Created by Данил on 28/10/2026.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
  var view: ProfileViewProtocol? { get set }
  
  func viewDidLoad()
  func didTapExit()
  func didConfirmLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
  weak var view: ProfileViewProtocol?
  private var profileImageServiceObserver: NSObjectProtocol?
  
  private let profileService: ProfileServiceProtocol
  private let profileImageService: ProfileImageServiceProtocol
  private let logoutService: ProfileLogoutServiceProtocol
  
  init(
    profileService: ProfileServiceProtocol = ProfileService.shared,
    profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
    logoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared
  ) {
    self.profileService = profileService
    self.profileImageService = profileImageService
    self.logoutService = logoutService
  }
  
  deinit {
    if let observer = profileImageServiceObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  func viewDidLoad() {
    if let profile = profileService.profile {
      view?.showProfile(profile: profile)
    }
    
    profileImageServiceObserver = NotificationCenter.default
      .addObserver(
        forName: ProfileImageService.didChangeNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        guard let self = self else { return }
        self.updateAvatar()
      }
    
    updateAvatar()
  }
  
  func didTapExit() {
    view?.showAlertExitWarning()
  }
  
  func didConfirmLogout() {
    logoutService.logout()
    view?.switchToSplashViewController()
  }
  
  private func updateAvatar() {
    guard
      let urlString = profileImageService.profileImage?.small,
      let url = URL(string: urlString)
    else { return }
    view?.showAvatar(url: url)
  }
}
