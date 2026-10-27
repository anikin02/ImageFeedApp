//
//  AuthViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 06/10/2026.
//

import UIKit

final class AuthViewController: UIViewController {
  // MARK: - Properties
  weak var delegate: AuthViewControllerDelegate?
  
  private let showWebViewSegueIdentifier: String = "ShowWebView"
  private let alertPresenter: AlertPresenter = .init()
  private let oauth2Service: OAuth2Service = .shared
  private let storage: OAuth2TokenStorage = .shared
  private let loginButton: UIButton = .init()
  private let logoImageView: UIImageView = .init()
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI()
  }
  
  // MARK: - Private Methods
  private func configUI() {
    view.backgroundColor = .ypBlackIOS
    
    configBackButton()
    configLoginButton()
    configLogoImage()
  }
  
  private func configLoginButton() {
    loginButton.setTitle("Войти", for: .normal)
    loginButton.setTitleColor(UIColor.ypBlackIOS, for: .normal)
    loginButton.backgroundColor = .ypWhiteIOS
    loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(loginButton)
    
    NSLayoutConstraint.activate([
      loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
      loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      loginButton.heightAnchor.constraint(equalToConstant: 48)
    ])
    
    loginButton.layer.cornerRadius = 16
    loginButton.layer.masksToBounds = true
  }
  
  @objc private func didTapLoginButton() {
    let webViewVC = WebViewViewController()
    let authHelper = AuthHelper()
    let webViewPresenter = WebViewPresenter(authHelper: authHelper)
    webViewVC.delegate = self
    webViewVC.presenter = webViewPresenter
    webViewPresenter.view = webViewVC
    
    navigationController?.pushViewController(webViewVC, animated: true)
  }
  
  private func configLogoImage() {
    logoImageView.image = UIImage(named: "Logo_of_Unsplash")
    
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(logoImageView)
    
    NSLayoutConstraint.activate([
      logoImageView.heightAnchor.constraint(equalToConstant: 60),
      logoImageView.widthAnchor.constraint(equalToConstant: 60),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  private func configBackButton() {
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Bakcward")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Bakcward")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .ypBlackIOS
  }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    UIBlockingProgressHUD.show()
    
    navigationController?.popViewController(animated: true)
    
    oauth2Service.fetchOAuthToken(code) { [weak self] result in
      UIBlockingProgressHUD.dismiss()
      guard let self else {
        return
      }
      switch result {
        case .success(let token):
          self.storage.token = token
          self.delegate?.didAuthenticate(self)
          
        case .failure(let error):
          print("[webViewViewController(_:didAuthenticateWithCode:)]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
          self.alertPresenter.show(in: self, model: AlertModel.getSimpleErrorAlertModel())
      }
    }
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    vc.dismiss(animated: true)
  }
}

// MARK: - AuthViewControllerDelegate Protocol
protocol AuthViewControllerDelegate: AnyObject {
  func didAuthenticate(_ vc: AuthViewController)
}
