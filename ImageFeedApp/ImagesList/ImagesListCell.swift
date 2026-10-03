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
  
  private let gradientLayer = CAGradientLayer()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupGradient()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if let cellImage = cellImage {
      gradientLayer.frame = CGRect(
        x: 0,
        y: cellImage.bounds.height - 30,
        width: cellImage.bounds.width,
        height: 30
      )
    }
  }
  
  func configure(image: UIImage, isLiked: Bool, date: String) {
    cellImage?.image = image
    let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
    likeButton?.setImage(likeImage, for: .normal)
    dateLabel?.text = date
  }
  
  private func setupGradient() {
    gradientLayer.colors = [
      UIColor.ypBlackIOS.withAlphaComponent(0.0).cgColor,
      UIColor.ypBackgroundIOS.cgColor
    ]
    
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    cellImage?.clipsToBounds = true
    cellImage?.layer.addSublayer(gradientLayer)
  }
}
