//
//  Untitled.swift
//  ImageFeedApp
//
//  Created by Данил on 28/10/2026.
//
import ImageFeedApp
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
  var presenter: WebViewPresenterProtocol?
  var loadRequestCalled: Bool = false
  
  func load(request: URLRequest) {
    loadRequestCalled = true
  }
  
  func setProgressValue(_ newValue: Float) {
    
  }
  
  func setProgressHidden(_ isHidden: Bool) {
    
  }
}
