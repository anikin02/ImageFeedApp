//
//  SplashViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//

import UIKit

final class SplashViewController: UIViewController {
  private let storage = OAuth2TokenStorage()
  
  private let showAuthenticationScreenSegueIdentifier: String = "showAuthenticationScreen"
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if storage.token != nil  {
      switchToTabBarController()
    } else {
      performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
    }
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
}

extension SplashViewController: AuthViewControllerDelegate {
  func didAuthenticate(_ vc: AuthViewController) {
    vc.dismiss(animated: true) { [weak self] in
      self?.switchToTabBarController()
    }
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
