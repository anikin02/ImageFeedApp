//
//  ImagesListCell.swift
//  ImageFeedApp
//
//  Created by Данил on 01/10/2026.
//
import UIKit

final class ImagesListCell: UITableViewCell {
  static let reuseIdentifier: String = "ImagesListCell"
  
  @IBOutlet weak private var cellImage: UIImageView?
  @IBOutlet weak private var dateLabel: UILabel?
  @IBOutlet weak private var likeButton: UIButton?
  
  func configure(image: UIImage, isLiked: Bool, date: String) {
    cellImage?.image = image
    let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
    likeButton?.setImage(likeImage, for: .normal)
    dateLabel?.text = date
  }
}
