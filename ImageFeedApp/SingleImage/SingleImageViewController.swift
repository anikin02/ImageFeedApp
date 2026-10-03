//
//  SingleImageViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak private var scrollView: UIScrollView?
  @IBOutlet weak private var imageView: UIImageView?
  
  // MARK: - Properties
  var image: UIImage? {
    didSet {
      guard isViewLoaded else { return }
      configImageView()
      rescaleAndCenterImageInScrollView(image: image)
    }
  }
  
  // MARK: - Lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configScrollView()
    configImageView()
    rescaleAndCenterImageInScrollView(image: image)
  }
  
  // MARK: - Actions
  @IBAction private func didTapBackButton() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func didTapSshareButton(_ sender: Any) {
    guard let image else { return }
    
    let objectsToShare: [Any] = [image]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    self.present(activityVC, animated: true, completion: nil)
  }
  
  // MARK: - Private Methods
  private func configImageView() {
    guard let image, let imageView else { return }
    imageView.image = image
    imageView.frame.size = image.size
    print(2)
  }
  
  private func rescaleAndCenterImageInScrollView(image: UIImage?) {
    guard let scrollView, let image else { return }
    print(3)
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
    guard let scrollView else { return }
    
    let verticalInset = max(
      0,
      (scrollView.bounds.height - scrollView.contentSize.height) / 2
    )
    
    let horizontalInset = max(
      0,
      (scrollView.bounds.width - scrollView.contentSize.width) / 2
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
  
  private func configScrollView() {
    guard let scrollView else { return }
    print(1)
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 1.25
  }
}
