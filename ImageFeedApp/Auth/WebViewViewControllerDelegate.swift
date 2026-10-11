//
//  WebViewViewControllerDelegate.swift
//  ImageFeedApp
//
//  Created by Данил on 07/10/2026.
//

protocol WebViewViewControllerDelegate: AnyObject {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
  func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
