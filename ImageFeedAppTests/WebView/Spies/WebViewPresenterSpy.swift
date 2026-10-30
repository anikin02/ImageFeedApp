//
//  WebViewPresenterSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 27/10/2026.
//

import ImageFeedApp
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
  var viewDidLoadCalled: Bool = false
  weak var view: WebViewViewControllerProtocol?
  
  func viewDidLoad() {
    viewDidLoadCalled = true
  }
  
  func didUpdateProgressValue(_ newValue: Double) {}
  
  func code(from url: URL) -> String? {
    return nil
  }
}
