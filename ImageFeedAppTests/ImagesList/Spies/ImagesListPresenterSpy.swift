//
//  ImagesListPresenterSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 01/11/2026.
//
@testable import ImageFeedApp
import Foundation

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
