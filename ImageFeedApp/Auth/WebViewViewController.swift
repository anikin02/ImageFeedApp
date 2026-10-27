//
//  WebViewViewController.swift.swift
//  ImageFeedApp
//
//  Created by Данил on 06/10/2026.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
  var presenter: WebViewPresenterProtocol? { get set }
  func load(request: URLRequest)
  func setProgressValue(_ newValue: Float)
  func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
  // MARK: - Properties
  var presenter: WebViewPresenterProtocol?
  private var webView: WKWebView = .init()
  private var progressView: UIProgressView = .init()
  private var estimatedProgressObservation: NSKeyValueObservation?
  weak var delegate: WebViewViewControllerDelegate?
  
  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
       options: [],
       changeHandler: { [weak self] _, _ in
         guard let self else { return }
         self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
       })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.navigationDelegate = self
    configUI()
    presenter?.viewDidLoad()
  }
  
  // MARK: - WebViewViewControllerProtocol
  func load(request: URLRequest) {
    webView.load(request)
  }
  
  func setProgressValue(_ newValue: Float) {
    progressView.progress = newValue
  }
  
  func setProgressHidden(_ isHidden: Bool) {
    progressView.isHidden = isHidden
  }
  
  // MARK: - Private Methods
  @objc private func didTapBackButton(_ sender: Any?) {
    delegate?.webViewViewControllerDidCancel(self)
  }
  
  private func configUI() {
    view.backgroundColor = .ypWhiteIOS
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
    progressView.progressTintColor = .ypBlackIOS
    view.addSubview(progressView)
    
    NSLayoutConstraint.activate([
      progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
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
    if let url = navigationAction.request.url {
      return presenter?.code(from: url)
    }
    return nil
  }
}
