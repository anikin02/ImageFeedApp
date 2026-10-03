//
//  ViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 30/09/2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
  @IBOutlet private var tableView: UITableView?
  
  private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
  private let photosName: [String] = Array(0..<20).map{ "\($0)" }
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configTableView()
  }
  
  private func configTableView() {
    tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showSingleImageSegueIdentifier {
      guard
        let viewController = segue.destination as? SingleImageViewController,
        let indexPath = sender as? IndexPath
      else {
        assertionFailure("Invalid segue destination")
        return
      }
      
      let image = UIImage(named: photosName[indexPath.row])
      viewController.image = image
    } else {
      super.prepare(for: segue, sender: sender)
    }
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
    performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
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
