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
  private var webView: WKWebView = .init()
  private var progressView: UIProgressView = .init()
  
  private var estimatedProgressObservation: NSKeyValueObservation?
  
  private enum WebViewConstants {
    static let unsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
  }
  
  weak var delegate: WebViewViewControllerDelegate?
  
  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    estimatedProgressObservation = webView.observe(
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
    
    webView.navigationDelegate = self
    configUI()
    loadAuthView()
  }
  
  // MARK: - Private Methods
  @objc private func didTapBackButton(_ sender: Any?) {
    delegate?.webViewViewControllerDidCancel(self)
  }
  
  private func updateProgress() {
    progressView.progress = Float(webView.estimatedProgress)
    progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
  }
  
  private func configUI() {
    configWebView()
    configProgressView()
  }
  
  private func configWebView() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func configProgressView() {
    progressView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(progressView)
    
    NSLayoutConstraint.activate([
      progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func loadAuthView() {
    guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
      let error = URLError(.badURL)
      print("[loadAuthView]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
      return
    }
    
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.accessKey),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: Constants.accessScope)
    ]
    
    guard let url = urlComponents.url else {
      let error = URLError(.badURL)
      print("[loadAuthView]: \(String(describing: type(of: error))) - \(error.localizedDescription)")
      return
    }
    
    let request = URLRequest(url: url)
    webView.load(request)
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
