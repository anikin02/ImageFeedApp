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
  private let oauth2Service: OAuth2Service = OAuth2Service.shared
  private let storage: OAuth2TokenStorage = .init()
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBackButton()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == showWebViewSegueIdentifier else {
      super.prepare(for: segue, sender: sender)
      return
    }
    
    guard let webViewViewController = segue.destination as? WebViewViewController else {
      assertionFailure("Invalid segue destination")
      return
    }
    
    webViewViewController.delegate = self
    
  }
  
  // MARK: - Private Methods
  private func configureBackButton() {
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Bakcward")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Bakcward")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .ypBlackIOS
  }
  
  private func getAlertModel()-> AlertModel {
    .init(title: "Что-то пошло не так(",
          message: "Не удалось войти в систему",
          buttonText: "ОК")
  }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    oauth2Service.fetchOAuthToken(code) { [weak self] result in
      guard let self else { return }
      switch result {
        case .success(let token):
          storage.token = token
          UIBlockingProgressHUD.show()
          delegate?.didAuthenticate(self)
        case .failure(let error):
          alertPresenter.show(in: self, model: self.getAlertModel())
          print(error.localizedDescription)
      }
      
      vc.dismiss(animated: true)
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
