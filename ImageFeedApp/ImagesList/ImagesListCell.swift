//
//  ImagesListCell.swift
//  ImageFeedApp
//
//  Created by Данил on 01/10/2026.
//
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
  static let reuseIdentifier: String = "ImagesListCell"
  var photoUrl: String?
  var onImageLoadSuccess: (() -> Void)?
  weak var delegate: ImagesListCellDelegate?
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    dateLabel.text = ""
    likeButton.setImage(UIImage(named: "No Active"), for: .normal)
    cellImage.kf.cancelDownloadTask()
    cellImage.image = nil
    onImageLoadSuccess = nil
  }
  
  func configCell(stringUrl: String, isLiked: Bool, date: String) {
    photoUrl = stringUrl
    cellImage.kf.indicatorType = .activity
    let placeholder = UIImage(named: "Stub")
    cellImage.tintColor = .ypWhiteAlpha50IOS
    cellImage.contentMode = .center
    cellImage.kf.setImage(with: URL(string: stringUrl), placeholder: placeholder) { [weak self] result in
      if case .success = result {
        self?.onImageLoadSuccess?()
        self?.cellImage.tintColor = nil
        self?.cellImage.contentMode = .scaleAspectFit
      }
    }
    setIsLike(with: isLiked)
    dateLabel.text = date
  }
  
  func setIsLike(with isLiked: Bool) {
    let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
    likeButton.setImage(likeImage, for: .normal)
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
    likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    contentView.addSubview(likeButton)
    NSLayoutConstraint.activate([
      likeButton.widthAnchor.constraint(equalToConstant: 44),
      likeButton.heightAnchor.constraint(equalToConstant: 44),
      likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
      likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor)
    ])
  }
  
  @objc private func didTapLikeButton() {
    delegate?.imageListCellDidTapLike(self)
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
