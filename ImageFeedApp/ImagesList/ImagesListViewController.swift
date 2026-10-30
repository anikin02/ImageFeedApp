//
//  ViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 30/09/2026.
//

import UIKit

protocol ImagesListViewProtocol: AnyObject {
  var presenter: ImagesListPresenterProtocol? { get set }
  func insertRows(in range: Range<Int>)
  func setLike(_ isLiked: Bool, at indexPath: Int)
  func showSingleImage(url: String)
  func showLoading()
  func hideLoading()
  func showErrorAlert()
}

final class ImagesListViewController: UIViewController & ImagesListViewProtocol {
  // MARK: - Properties
  var presenter: ImagesListPresenterProtocol?
  private var tableView: UITableView = .init()
  private let alertPresenter: AlertPresenter = .init()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .ypBlackIOS
    configTableView()
    presenter?.viewDidLoad()
  }
  
  // MARK: - ImagesListViewProtocol
  func insertRows(in range: Range<Int>) {
    let indexPaths = range.map { IndexPath(row: $0, section: 0) }
    tableView.performBatchUpdates {
      tableView.insertRows(at: indexPaths, with: .automatic)
    }
  }
  
  func setLike(_ isLiked: Bool, at indexPath: Int) {
    let indexPath = IndexPath(row: indexPath, section: 0)
    (tableView.cellForRow(at: indexPath) as? ImagesListCell)?.setIsLike(with: isLiked)
  }
  
  func showSingleImage(url: String) {
    let singleImageVC = SingleImageViewController()
    singleImageVC.stringUrlImage = url
    singleImageVC.hidesBottomBarWhenPushed = true
    
    let navController = UINavigationController(rootViewController: singleImageVC)
    navController.modalPresentationStyle = .fullScreen
    navController.setNavigationBarHidden(true, animated: false)
    present(navController, animated: true)
  }
  
  func showLoading() {
    UIBlockingProgressHUD.show()
  }
  
  func hideLoading() {
    UIBlockingProgressHUD.dismiss()
  }
  
  func showErrorAlert() {
    alertPresenter.show(in: self, model: AlertModel.getSimpleErrorAlertModel())
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
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter?.photosCount ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
      return UITableViewCell()
    }
    
    guard let presenter else {
      return UITableViewCell()
    }
    
    let photo = presenter.cellViewModel(at: indexPath.row)
    
    imageListCell.configCell(
      stringUrl: photo.thumbImageURL,
      isLiked: photo.isLiked,
      date: presenter.dateFormatter.string(from: photo.createdAt ?? Date())
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
    presenter?.didSelectRow(at: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    presenter?.heightForRow(at: indexPath.row, tableWidth: tableView.bounds.width) ?? 0
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    presenter?.willDisplayRow(at: indexPath.row)
  }
}


// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
  func imageListCellDidTapLike(_ cell: ImagesListCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    
    presenter?.didTapLike(at: indexPath.row)
  }
}
