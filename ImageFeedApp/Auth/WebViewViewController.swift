//
//  WebViewViewController.swift.swift
//  ImageFeedApp
//
//  Created by Данил on 06/10/2026.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet private weak var webView: WKWebView?
  @IBOutlet private weak var progressView: UIProgressView?
  
  private var estimatedProgressObservation: NSKeyValueObservation?
  
  private enum WebViewConstants {
    static let unsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
  }
  
  weak var delegate: WebViewViewControllerDelegate?
  
  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    estimatedProgressObservation = webView?.observe(
      \.estimatedProgress,
       options: [],
       changeHandler: { [weak self] _, _ in
         guard let self = self else { return }
         self.updateProgress()
       })
    updateProgress()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView?.navigationDelegate = self
    
    loadAuthView()
  }
  
  // MARK: - IBActions
  @IBAction private func didTapBackButton(_ sender: Any?) {
    delegate?.webViewViewControllerDidCancel(self)
  }
  
  // MARK: - Private Methods
  private func updateProgress() {
    guard let webView, let progressView else {
      return
    }
    progressView.progress = Float(webView.estimatedProgress)
    progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
  }
  
  private func loadAuthView() {
    guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
      print("Failed to create URLComponents")
      return
    }
    
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.accessKey),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: Constants.accessScope)
    ]
    
    guard let url = urlComponents.url else {
      print("Failed to create URL")
      return
    }
    
    let request = URLRequest(url: url)
    webView?.load(request)
  }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    if let code = code(from: navigationAction) {
      delegate?.webViewViewController(self, didAuthenticateWithCode: code)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
  
  private func code(from navigationAction: WKNavigationAction) -> String? {
    if
      let url = navigationAction.request.url,
      let urlComponents = URLComponents(string: url.absoluteString),
      urlComponents.path == "/oauth/authorize/native",
      let items = urlComponents.queryItems,
      let codeItem = items.first(where: { $0.name == "code" })
    {
      return codeItem.value
    } else {
      return nil
    }
  }
}
