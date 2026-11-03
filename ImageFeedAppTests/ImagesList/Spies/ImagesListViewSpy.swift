//
//  ImagesListViewSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 01/11/2026.
//
@testable import ImageFeedApp
import Foundation

final class ImagesListViewSpy: ImagesListViewProtocol {
  var presenter: ImagesListPresenterProtocol?
  
  var onInsertRows: (() -> Void)?
  
  var insertedRange: Range<Int>?
  var insertRowsCallsCount = 0
  var setLikeArguments: (isLiked: Bool, index: Int)?
  var shownImageURL: String?
  var showLoadingCalled = false
  var hideLoadingCalled = false
  var showErrorAlertCalled = false
  
  func insertRows(in range: Range<Int>) {
    insertedRange = range
    insertRowsCallsCount += 1
    onInsertRows?()
  }
  
  func setLike(_ isLiked: Bool, at indexPath: Int) {
    setLikeArguments = (isLiked, indexPath)
  }
  
  func showSingleImage(url: String) { shownImageURL = url }
  func showLoading() { showLoadingCalled = true }
  func hideLoading() { hideLoadingCalled = true }
  func showErrorAlert() { showErrorAlertCalled = true }
}
