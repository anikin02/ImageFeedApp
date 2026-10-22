//
//  ImagesListCell.swift
//  ImageFeedApp
//
//  Created by Данил on 01/10/2026.
//
import UIKit

final class ImagesListCell: UITableViewCell {
  static let reuseIdentifier: String = "ImagesListCell"
  
  private var cellImage: UIImageView = .init()
  private var dateLabel: UILabel = .init()
  private var likeButton: UIButton = .init()
  
  private let gradientLayer = CAGradientLayer()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
      nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    gradientLayer.frame = CGRect(
      x: 0,
      y: cellImage.bounds.height - 30,
      width: cellImage.bounds.width,
      height: 30
    )
  }
  
  func configure(image: UIImage, isLiked: Bool, date: String) {
    cellImage.image = image
    let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
    likeButton.setImage(likeImage, for: .normal)
    dateLabel.text = date
  }
  
  private func configUI() {
    contentView.backgroundColor = .ypBlackIOS
    backgroundColor = .ypBlackIOS
    selectionStyle = .none
    
    configCellImage()
    configDateLabel()
    configLikeButton()
    setupGradient()
  }
  
  private func configCellImage() {
    cellImage.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(cellImage)
    NSLayoutConstraint.activate([
      cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
      cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
    cellImage.layer.cornerRadius = 16
    cellImage.layer.masksToBounds = true
  }
  
  private func configDateLabel() {
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    dateLabel.textColor = .ypWhiteIOS
    contentView.addSubview(dateLabel)
    NSLayoutConstraint.activate([
      dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
      dateLabel.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: -8),
      dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8)
    ])
  }
  
  private func configLikeButton() {
    likeButton.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(likeButton)
    NSLayoutConstraint.activate([
      likeButton.widthAnchor.constraint(equalToConstant: 44),
      likeButton.heightAnchor.constraint(equalToConstant: 44),
      likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
      likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor)
    ])
  }
  
  private func setupGradient() {
    gradientLayer.colors = [
      UIColor.ypBlackIOS.withAlphaComponent(0.0).cgColor,
      UIColor.ypBackgroundIOS.cgColor
    ]
    
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    cellImage.clipsToBounds = true
    cellImage.layer.addSublayer(gradientLayer)
  }
}
