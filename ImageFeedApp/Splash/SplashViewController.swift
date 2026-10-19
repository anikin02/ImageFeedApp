//
//  SplashViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//

import UIKit

final class SplashViewController: UIViewController {
  // MARK: - Properties
  private let storage = OAuth2TokenStorage()
  private let profileService: ProfileService = .shared
  private let profileImageService: ProfileImageService = .shared
  private var logoImage: UIImageView = .init()
  
  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    configUI()
    
    guard let token = storage.token else {
      presentAuthViewController()
      return
    }
    
    fetchProfile(token: token)
  }
  
  // MARK: - Private Methods
  private func configUI() {
    view.backgroundColor = .ypBlackIOS
    
    configImage()
  }
  
  private func configImage() {
    logoImage.translatesAutoresizingMaskIntoConstraints = false
    
    logoImage.image = UIImage(named: "logo")
    
    view.addSubview(logoImage)
    
    NSLayoutConstraint.activate([
      logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    ])
  }
  
  
  private func switchToTabBarController() {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    
    let tabBarController = UIStoryboard(name: "Main", bundle: .main)
      .instantiateViewController(withIdentifier: "TabBarViewController")
    
    window?.rootViewController = tabBarController
  }
  
  private func presentAuthViewController() {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
      assertionFailure("Не удалось найти AuthViewController по идентификатору")
      return
    }
    authViewController.delegate = self
    authViewController.modalPresentationStyle = .fullScreen
    present(authViewController, animated: true)
  }
  
  private func fetchProfile(token: String) {
    UIBlockingProgressHUD.show()
    profileService.fetchProfile(token) { [weak self] result in
      UIBlockingProgressHUD.dismiss()
      
      guard let self = self else { return }
      
      switch result {
        case let .success(profile):
          profileImageService.fetchProfileImageURL(profile.username) { _ in }
          
          self.switchToTabBarController()
          
        case .failure:
          break
      }
    }
  }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
  func didAuthenticate(_ vc: AuthViewController) {
    vc.dismiss(animated: true) {
      UIBlockingProgressHUD.dismiss()
    }
    
    guard let token = storage.token else {
      return
    }
    
    fetchProfile(token: token)
  }
}
