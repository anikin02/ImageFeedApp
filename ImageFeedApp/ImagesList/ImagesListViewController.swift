//
//  ViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 30/09/2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
  // MARK: - Properties
  private var tableView: UITableView = .init()
  private var photos: [Photo] = []
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  private let service: ImagesListService = .shared
  private var imagesListServiceObserver: NSObjectProtocol?
  private let alertPresenter: AlertPresenter = .init()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagesListServiceObserver = NotificationCenter.default.addObserver(
      forName: ImagesListService.didChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }
      self.updateTableViewAnimated()
    }
    
    view.backgroundColor = .ypBlackIOS
    
    service.fetchPhotosNextPage()
    configTableView()
  }
  
  // MARK: - Private Methods
  private func configTableView() {
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .ypBlackIOS
    tableView.separatorStyle = .none
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func updateTableViewAnimated() {
    let oldCount = photos.count
    let newCount = service.photos.count
    photos = service.photos
    if oldCount != newCount {
      tableView.performBatchUpdates {
        let indexPaths = (oldCount..<newCount).map { i in
          IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
      } completion: { _ in }
    }
  }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return service.photos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
      return UITableViewCell()
    }
    
    imageListCell.configCell(
      stringUrl: photos[indexPath.row].thumbImageURL,
      isLiked: photos[indexPath.row].isLiked,
      date: dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())
    )
    
    imageListCell.delegate = self
    
    imageListCell.onImageLoadSuccess = { [weak tableView] in
      UIView.performWithoutAnimation {
        tableView?.reloadRows(at: [indexPath], with: .automatic)
      }
    }
    
    return imageListCell
  }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let singleImageVC = SingleImageViewController()
      singleImageVC.stringUrlImage = photos[indexPath.row].largeImageURL
      singleImageVC.hidesBottomBarWhenPushed = true
  
      let navController = UINavigationController(rootViewController: singleImageVC)
      navController.modalPresentationStyle = .fullScreen
      navController.setNavigationBarHidden(true, animated: false)
  
      present(navController, animated: true, completion: nil)
    }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = photos[indexPath.row].size.width
    let scale = imageWidth == 0 ? 0 : imageViewWidth / imageWidth
    let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == photos.count - 1 {
      service.fetchPhotosNextPage()
    }
  }
}


// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
  func imageListCellDidTapLike(_ cell: ImagesListCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let photo = photos[indexPath.row]
    UIBlockingProgressHUD.show()
    
    service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
      switch result {
        case .success:
          self.photos = self.service.photos
          cell.setIsLike(with: self.photos[indexPath.row].isLiked)
          UIBlockingProgressHUD.dismiss()
        case .failure(_):
          UIBlockingProgressHUD.dismiss()
          self.alertPresenter.show(in: self, model: AlertModel.getSimpleErrorAlertModel())
      }
    }
  }
}
