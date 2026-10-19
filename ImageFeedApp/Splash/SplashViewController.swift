//
//  SplashViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//

import UIKit

final class SplashViewController: UIViewController {
  private let storage = OAuth2TokenStorage()
  private let profileService: ProfileService = .shared
  private let profileImageService: ProfileImageService = .shared
  
  private let showAuthenticationScreenSegueIdentifier: String = "showAuthenticationScreen"
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let token = storage.token else {
      performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
      return
    }
    
    fetchProfile(token: token)
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
  
  private func fetchProfile(token: String) {
    profileService.fetchProfile(token) { [weak self] result in
      
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

extension SplashViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showAuthenticationScreenSegueIdentifier {
      
      guard
        let navigationController = segue.destination as? UINavigationController,
        let viewController = navigationController.viewControllers.first as? AuthViewController
      else {
        assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
        return
      }
      
      viewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}
