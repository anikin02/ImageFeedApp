//
//  ImageFeedAppUITests.swift
//  ImageFeedAppUITests
//
//  Created by Данил on 01/11/2026.
//

import XCTest

final class ImageFeedAppUITests: XCTestCase {
  
  private let app = XCUIApplication()
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launch()
  }
  
  func testAuth() throws {
    let login = ""
    let password = ""
    app.buttons["Authenticate"].tap()
    
    let webView = app.webViews["UnsplashWebView"]
    
    XCTAssertTrue(webView.waitForExistence(timeout: 10))
    
    let loginTextField = webView.descendants(matching: .textField).element
    XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
    loginTextField.tap()
    loginTextField.typeText(login)
    
    let passwordTextField = webView.descendants(matching: .secureTextField).element
    XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
    for char in password {
      let hasFocus = (passwordTextField.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
      if !hasFocus {
        passwordTextField.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.1)).tap()
      }
      passwordTextField.typeText(String(char))
    }
    
    webView.buttons["Login"].tap()
    
    let tablesQuery = app.tables
    let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
    
    XCTAssertTrue(cell.waitForExistence(timeout: 10))
  }
  
  func testFeed() throws {
    let tablesQuery = app.tables
    
    let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
    XCTAssertTrue(cell.waitForExistence(timeout: 10))
    
    cell.swipeUp()
    
    let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
    
    sleep(5)
    
    cellToLike.buttons["No Active button"].tap()
    
    sleep(5)
    
    cellToLike.buttons["Active button"].tap()
    
    sleep(5)
    
    cellToLike.tap()
    
    sleep(30)
    
    let image = app.scrollViews.images.element(boundBy: 0)
    image.pinch(withScale: 3, velocity: 1)
    image.pinch(withScale: 0.5, velocity: -1)
    
    let navBackButtonWhiteButton = app.buttons["back button"]
    navBackButtonWhiteButton.tap()
  }
  
  func testProfile() throws {
    sleep(10)
    app.tabBars.buttons.element(boundBy: 1).tap()
    
    XCTAssertTrue(app.staticTexts["nameLabel"].exists)
    XCTAssertTrue(app.staticTexts["username"].exists)
    
    app.buttons["logout button"].tap()
    
    app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
  }
}
