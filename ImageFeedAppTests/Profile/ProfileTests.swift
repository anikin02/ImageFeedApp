//
//  ProfileTests.swift
//  ImageFeedApp
//
//  Created by Данил on 30/10/2026.
//

@testable import ImageFeedApp
import XCTest
import Foundation

final class ProfileTests: XCTestCase {
  
  func testProfileViewControllerCallsViewDidLoad() {
    // given
    let viewController = ProfileViewController()
    let presenter = ProfilePresenterSpy()
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    _ = viewController.view
    
    //then
    XCTAssertTrue(presenter.viewDidLoadCalled)
  }
  
  func testShowAlertCalled() {
    // given
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfilePresenter()
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    presenter.didTapExit()
    
    //then
    XCTAssertTrue(viewController.showAlertCalled)
  }
  
  func testLogoutCalled() {
    // given
    let logoutService = ProfileLogoutServiceSpy()
    let presenter = ProfilePresenter(logoutService: logoutService)
    
    // when
    presenter.didConfirmLogout()
    
    //then
    XCTAssertTrue(logoutService.logoutCalled)
  }
  
  func testSwitchToSplashViewControllerCalled() {
    // given
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfilePresenter(logoutService: ProfileLogoutServiceSpy())
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    presenter.didConfirmLogout()
    
    //then
    XCTAssertTrue(viewController.switchToSplashViewControllerCalled)
  }
  
  func testShowProfileCalled() {
    // given
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfilePresenter(profileService: ProfileServiceSpy())
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    presenter.viewDidLoad()
    
    //then
    XCTAssertTrue(viewController.showProfileCalled)
  }
  
  func testShowAvatarCalled() {
    // given
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfilePresenter(profileImageService: ProfileImageServiceSpy())
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    presenter.viewDidLoad()
    
    //then
    XCTAssertTrue(viewController.showAvatarCalled)
  }
}
