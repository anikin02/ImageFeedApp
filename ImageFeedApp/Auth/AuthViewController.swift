//
//  AuthViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 06/10/2026.
//

import UIKit

final class AuthViewController: UIViewController {
  private let showWeViewSegueIdentifier: String = "ShowWebView"
  private let oauth2Service: OAuth2Service = OAuth2Service.shared
  private let storage: OAuth2TokenStorage = .init()
  var delegate: AuthViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showWeViewSegueIdentifier {
      guard
        let webViewViewController = segue.destination as? WebViewViewController
      else {
        assertionFailure("Invalid segue destination")
        return
      }
      webViewViewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  private func configureBackButton() {
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Bakcward")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Bakcward")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = .ypBlackIOS
  }
}

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    oauth2Service.fetchOAuthToken(code) { [weak self] result in
      guard let self else { return }
      switch result {
        case .success(let token):
          storage.token = token
          delegate?.didAuthenticate(self)
        case .failure(let error):
          print(error.localizedDescription)
      }
      
      vc.dismiss(animated: true)
    }
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    vc.dismiss(animated: true)
  }
}

protocol AuthViewControllerDelegate: AnyObject {
  func didAuthenticate(_ vc: AuthViewController)
}
