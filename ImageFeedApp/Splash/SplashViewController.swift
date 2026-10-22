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
    storage.token = nil
    guard let _ = storage.token else {
      presentAuthViewController()
      return
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    
    guard let token = storage.token else {
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
    
    let tabBarController = TabBarController()
    
    window?.rootViewController = tabBarController
  }
  
  private func presentAuthViewController() {
    
    let authVC = AuthViewController()
    authVC.delegate = self
    
    let navigationController = UINavigationController(
      rootViewController: authVC
    )
    
    navigationController.modalPresentationStyle = .fullScreen
    
    present(navigationController, animated: true)
  }
  
  private func fetchProfile(token: String) {
    UIBlockingProgressHUD.show()
    profileService.fetchProfile(token) { [weak self] result in
      UIBlockingProgressHUD.dismiss()
      
      guard let self = self else { return }
      
      switch result {
        case let .success(profile):
          profileImageService.fetchProfileImageURL(profile.username) { result in
            if case .failure(let error) = result {
              print("[fetchProfileImageURL]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
            }
          }
          
          self.switchToTabBarController()
          
        case .failure(let error):
          print("[fetchProfile]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
      }
    }
  }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
  func didAuthenticate(_ vc: AuthViewController) {
    vc.dismiss(animated: true) {
      UIBlockingProgressHUD.dismiss()
      guard let token = self.storage.token else {
        return
      }
      
      self.fetchProfile(token: token)
    }
  }
}
