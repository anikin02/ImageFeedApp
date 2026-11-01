//
//  ImagesListTests.swift
//  ImageFeedApp
//
//  Created by Данил on 01/11/2026.
//

@testable import ImageFeedApp
import XCTest
import Foundation

final class ImagesListTests: XCTestCase {

  func testImagesListViewControllerCallsViewDidLoad() {
    // given
    let viewController = ImagesListViewController()
    let presenter = ImagesListPresenterSpy()
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    _ = viewController.view
    
    // then
    XCTAssertTrue(presenter.viewDidLoadCalled)
  }
  
  func testViewDidLoadFetchesPhotos() {
    // given
    let service = ImagesListServiceSpy()
    let presenter = ImagesListPresenter(service: service)
    
    // when
    presenter.viewDidLoad()
    
    // then
    XCTAssertEqual(service.fetchPhotosNextPageCallsCount, 1)
  }
  
  func testNotificationInsertsNewRows() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub(id: "1"), .stub(id: "2"), .stub(id: "3")]
    let view = ImagesListViewSpy()
    let presenter = ImagesListPresenter(service: service)
    presenter.view = view
    view.presenter = presenter
    
    let expectation = expectation(description: "Rows inserted")
    view.onInsertRows = { expectation.fulfill() }
    presenter.viewDidLoad()
    
    // when
    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    
    // then
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(view.insertedRange, 0..<3)
    XCTAssertEqual(presenter.displayedPhotosCount, 3)
  }
  
  func testCellViewModelContainsPhotoData() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [
      .stub(id: "1"),
      .stub(id: "2", thumbImageURL: "https://example.com/thumb.jpg", isLiked: true)
    ]
    let presenter = ImagesListPresenter(service: service)
    
    // when
    let model = presenter.cellViewModel(at: 1)
    
    // then
    XCTAssertEqual(model.stringUrl, "https://example.com/thumb.jpg")
    XCTAssertTrue(model.isLiked)
  }
  
  func testHeightForRowScalesImageToTableWidth() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub(size: CGSize(width: 200, height: 100))]
    let presenter = ImagesListPresenter(service: service)
    
    // when
    let height = presenter.heightForRow(at: 0, tableWidth: 232)
    
    // then
    XCTAssertEqual(height, 108, accuracy: 0.001)
  }
  
  func testHeightForRowWithZeroImageWidthReturnsOnlyInsets() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub(size: CGSize(width: 0, height: 100))]
    let presenter = ImagesListPresenter(service: service)
    
    // when
    let height = presenter.heightForRow(at: 0, tableWidth: 300)
    
    // then
    XCTAssertEqual(height, 8, accuracy: 0.001)
  }
  
  func testWillDisplayLastRowFetchesNextPage() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub(id: "1"), .stub(id: "2")]
    let presenter = ImagesListPresenter(service: service)
    
    // when
    presenter.willDisplayRow(at: 1)
    
    // then
    XCTAssertEqual(service.fetchPhotosNextPageCallsCount, 1)
  }
  
  func testWillDisplayNotLastRowDoesNotFetchNextPage() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub(id: "1"), .stub(id: "2")]
    let presenter = ImagesListPresenter(service: service)
    
    // when
    presenter.willDisplayRow(at: 0)
    
    // then
    XCTAssertEqual(service.fetchPhotosNextPageCallsCount, 0)
  }
  
  func testDidSelectRowShowsLargeImage() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub(largeImageURL: "https://example.com/large.jpg")]
    let view = ImagesListViewSpy()
    let presenter = ImagesListPresenter(service: service)
    presenter.view = view
    
    // when
    presenter.didSelectRow(at: 0)
    
    // then
    XCTAssertEqual(view.shownImageURL, "https://example.com/large.jpg")
  }
  
  func testDidTapLikeShowsLoading() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub()]
    let view = ImagesListViewSpy()
    let presenter = ImagesListPresenter(service: service)
    presenter.view = view
    
    // when
    presenter.didTapLike(at: 0)
    
    // then
    XCTAssertTrue(view.showLoadingCalled)
  }
  
  func testDidTapLikeCallsServiceChangeLike() {
    // given
    let service = ImagesListServiceSpy()
    service.photos = [.stub()]
    let presenter = ImagesListPresenter(service: service)
    
    // when
    presenter.didTapLike(at: 0)
    
    // then
    XCTAssertTrue(service.changeLikeCalled)
  }
}

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

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
  var view: ImagesListViewProtocol?
  var dateFormatter = DateFormatter()
  var displayedPhotosCount = 0
  var viewDidLoadCalled = false
  
  func cellViewModel(at indexPath: Int) -> CellModel {return .init(stringUrl: "", isLiked: true, stringDate: "")}
  
  func viewDidLoad() {
    viewDidLoadCalled = true
  }
  
  func heightForRow(at indexPath: Int, tableWidth: CGFloat) -> CGFloat { 0 }
  func willDisplayRow(at indexPath: Int) {}
  func didSelectRow(at indexPath: Int) {}
  func didTapLike(at indexPath: Int) {}
}

final class ImagesListServiceSpy: ImagesListServiceProtocol {
  var photos: [Photo] = []
  var fetchPhotosNextPageCallsCount = 0
  var changeLikeArguments: (id: String, isLike: Bool)?
  var changeLikeCalled = false
  
  func fetchPhotosNextPage() {
    fetchPhotosNextPageCallsCount += 1
  }
  
  func logout() {}
  
  func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void
  ) {
    changeLikeCalled = true
  }
}

extension Photo {
  static func stub(
    id: String = "1",
    size: CGSize = CGSize(width: 100, height: 100),
    thumbImageURL: String = "",
    largeImageURL: String = "",
    isLiked: Bool = false
  ) -> Photo {
    Photo(
      id: id,
      size: size,
      createdAt: nil,
      welcomeDescription: nil,
      thumbImageURL: thumbImageURL,
      largeImageURL: largeImageURL,
      isLiked: isLiked
    )
  }
}

