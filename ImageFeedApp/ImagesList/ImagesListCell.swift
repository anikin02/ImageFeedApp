//
//  ImagesListCell.swift
//  ImageFeedApp
//
//  Created by Данил on 01/10/2026.
//
import UIKit

final class ImagesListCell: UITableViewCell {
  static let reuseIdentifier: String = "ImagesListCell"
  
  @IBOutlet weak var cellImage: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
}
