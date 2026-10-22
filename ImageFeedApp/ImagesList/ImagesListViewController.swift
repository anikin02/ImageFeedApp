//
//  ViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 30/09/2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
  // MARK: - Outlets
  private var tableView: UITableView = .init()
  
  // MARK: - Properties
  private let photosName: [String] = Array(0..<20).map{ "\($0)" }
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .ypBlackIOS
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
}

extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photosName.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
      return UITableViewCell()
    }
    
    imageListCell.configure(
      image: UIImage(named: photosName[indexPath.row]) ?? UIImage(),
      isLiked: indexPath.row % 2 == 0,
      date: dateFormatter.string(from: Date())
    )
    
    return imageListCell
  }
}

extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let image = UIImage(named: photosName[indexPath.row]) else {
      return
    }
    let singleImageVC = SingleImageViewController()
    singleImageVC.image = image
    singleImageVC.hidesBottomBarWhenPushed = true
    
    let navController = UINavigationController(rootViewController: singleImageVC)
    navController.modalPresentationStyle = .fullScreen
    navController.setNavigationBarHidden(true, animated: false)
    
    present(navController, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let image = UIImage(named: photosName[indexPath.row]) else {
      return 0
    }
    
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = image.size.width
    let scale = imageWidth == 0 ? 0 : imageViewWidth / imageWidth
    let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}
