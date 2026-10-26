//
//  SingleImageViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
  // MARK: - Properties
  var stringUrlImage: String? {
    didSet {
      guard isViewLoaded else { return }
      updateImageView()
    }
  }
  private var scrollView: UIScrollView = .init()
  private var imageView: UIImageView = .init()
  private var shareButton: UIButton = .init()
  private var backButton: UIButton = .init()
  private let alertPresenter: AlertPresenter = .init()
  
  // MARK: - Lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
  }
  
  // MARK: - Private Methods
  @objc private func didTapBackButton() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func didTapShareButton(_ sender: Any) {
    guard let image = imageView.image else { return }
    
    let objectsToShare: [Any] = [image]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    self.present(activityVC, animated: true, completion: nil)
  }
  
  private func configUI() {
    view.backgroundColor = .ypBlackIOS
    navigationItem.hidesBackButton = false
    
    configScrollView()
    configImageView()
    rescaleAndCenterImageInScrollView()
    
    configBackButton()
    configShareButton()
  }
  
  private func configImageView() {
    scrollView.addSubview(imageView)
    updateImageView()
  }
  
  private func updateImageView() {
    guard let stringUrlImage else { return }
    
    UIBlockingProgressHUD.show()
    let placeholder = UIImage(named: "Stub")
    imageView.contentMode = .scaleAspectFill
    imageView.tintColor = .ypWhiteAlpha50IOS
    imageView.kf.setImage(with: URL(string: stringUrlImage), placeholder: placeholder) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let image):
          UIBlockingProgressHUD.dismiss()
          imageView.contentMode = .scaleAspectFit
          imageView.tintColor = nil
          imageView.frame = CGRect(origin: .zero, size: image.image.size)
          imageView.contentMode = .scaleAspectFit
          scrollView.contentSize = imageView.bounds.size
          rescaleAndCenterImageInScrollView()
        case .failure:
          showError()
          UIBlockingProgressHUD.dismiss()
      }
    }
  }
  
  private func showError() {
    let model = AlertModel(title: "Что-то пошло не так.",
                           message: "Попробовать ещё раз?",
                           buttons: [AlertButtonConfig(title: "Не надо", handler: nil),
                                     AlertButtonConfig(title: "Повторить", handler: updateImageView),])
    alertPresenter.show(in: self, model: model)
  }
  
  private func configScrollView() {
    scrollView.delegate = self
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 1.25
    
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.contentMode = .scaleToFill
    
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func configBackButton() {
    backButton.translatesAutoresizingMaskIntoConstraints = false
    backButton.setImage(UIImage(named: "Backward"), for: .normal)
    backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    backButton.contentMode = .scaleToFill
    
    view.addSubview(backButton)
    
    NSLayoutConstraint.activate([
      backButton.widthAnchor.constraint(equalToConstant: 48),
      backButton.heightAnchor.constraint(equalToConstant: 48),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9)
    ])
  }
  
  private func configShareButton() {
    shareButton.translatesAutoresizingMaskIntoConstraints = false
    shareButton.setImage(UIImage(named: "Sharing"), for: .normal)
    shareButton.addTarget(self, action: #selector(didTapShareButton(_:)), for: .touchUpInside)
    shareButton.contentMode = .scaleToFill
    view.addSubview(shareButton)
    
    NSLayoutConstraint.activate([
      shareButton.widthAnchor.constraint(equalToConstant: 50),
      shareButton.heightAnchor.constraint(equalToConstant: 50),
      shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
    ])
  }
  
  private func rescaleAndCenterImageInScrollView() {
    guard let image = imageView.image else { return }
    
    let minZoomScale = scrollView.minimumZoomScale
    let maxZoomScale = scrollView.maximumZoomScale
    view.layoutIfNeeded()
    let visibleRectSize = scrollView.bounds.size
    let imageSize = image.size
    let hScale = visibleRectSize.width / imageSize.width
    let vScale = visibleRectSize.height / imageSize.height
    let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
    scrollView.setZoomScale(scale, animated: false)
    scrollView.layoutIfNeeded()
    
    centerImageInScrollView()
  }
  
  private func centerImageInScrollView() {
    let verticalInset = max(
      0,
      (scrollView.bounds.height - imageView.frame.height) / 2
    )
    
    let horizontalInset = max(
      0,
      (scrollView.bounds.width - imageView.frame.width) / 2
    )
    
    scrollView.contentInset = UIEdgeInsets(
      top: verticalInset,
      left: horizontalInset,
      bottom: verticalInset,
      right: horizontalInset
    )
  }
}

extension SingleImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    centerImageInScrollView()
  }
}
