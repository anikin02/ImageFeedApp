//
//  ImageFeedAppUITestsLaunchTests.swift
//  ImageFeedAppUITests
//
//  Created by Данил on 01/11/2026.
//

import XCTest

final class ImageFeedAppUITestsLaunchTests: XCTestCase {
  
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  @MainActor
  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()
    
    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
