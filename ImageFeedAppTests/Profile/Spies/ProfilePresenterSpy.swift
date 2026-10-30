//
//  ProfilePresenterSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 29/10/2026.
//

@testable import ImageFeedApp
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
  var view: ProfileViewProtocol?
  var viewDidLoadCalled: Bool = false
  
  func viewDidLoad() {
    viewDidLoadCalled = true
  }
  
  func didTapExit() {}
  
  func didConfirmLogout() {}
}
