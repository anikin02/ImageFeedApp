//
//  ImagesListPresenter.swift
//  ImageFeedApp
//
//  Created by Данил on 30/10/2026.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
  var view: ImagesListViewProtocol? { get set }
  var photosCount: Int { get }
  var dateFormatter: DateFormatter { get }
  func viewDidLoad()
  func cellViewModel(at indexPath: Int) -> Photo
  func heightForRow(at indexPath: Int, tableWidth: CGFloat) -> CGFloat
  func willDisplayRow(at indexPath: Int)
  func didSelectRow(at indexPath: Int)
  func didTapLike(at indexPath: Int)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
  weak var view: (any ImagesListViewProtocol)?
  var photosCount: Int { photos.count }
  
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "d MMMM yyyy"
    return formatter
  }()
  private let service: ImagesListServiceProtocol
  private var photos: [Photo] { service.photos }
  private var imagesListServiceObserver: NSObjectProtocol?
  private var displayedPhotosCount = 0
  
  init(service: ImagesListServiceProtocol = ImagesListService.shared) {
    self.service = service
  }
  
  func viewDidLoad() {
    imagesListServiceObserver = NotificationCenter.default.addObserver(
      forName: ImagesListService.didChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }
      self.updatePhotos()
    }
    service.fetchPhotosNextPage()
  }
  
  func cellViewModel(at indexPath: Int) -> Photo {
    photos[indexPath]
  }
  
  func heightForRow(at indexPath: Int, tableWidth: CGFloat) -> CGFloat {
    let insets = (top: CGFloat(4), left: CGFloat(16), bottom: CGFloat(4), right: CGFloat(16))
    let imageViewWidth = tableWidth - insets.left - insets.right
    let size = photos[indexPath].size
    let scale = size.width == 0 ? 0 : imageViewWidth / size.width
    return size.height * scale + insets.top + insets.bottom
  }
  
  func willDisplayRow(at indexPath: Int) {
    if indexPath == photos.count - 1 {
      service.fetchPhotosNextPage()
    }
  }
  
  func didSelectRow(at indexPath: Int) {
    view?.showSingleImage(url: photos[indexPath].largeImageURL)
  }
  
  func didTapLike(at indexPath: Int) {
    let photo = photos[indexPath]
    view?.showLoading()
    
    service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
      guard let self else { return }
      self.view?.hideLoading()
      switch result {
        case .success:
          self.view?.setLike(self.photos[indexPath].isLiked, at: indexPath)
        case .failure(_):
          self.view?.showErrorAlert()
      }
    }
  }
  
  private func updatePhotos() {
    let newCount = photos.count
    guard displayedPhotosCount != newCount else { return }
    let range = displayedPhotosCount..<newCount
    displayedPhotosCount = newCount
    view?.insertRows(in: range)
  }
  
}
