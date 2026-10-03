//
//  SingleImageViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
  var image: UIImage? {
    didSet {
      guard isViewLoaded else { return }
      configImageView()
      rescaleAndCenterImageInScrollView(image: image)
    }
  }
  
  @IBOutlet weak private var scrollView: UIScrollView?
  @IBOutlet weak private var imageView: UIImageView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configImageView()
    rescaleAndCenterImageInScrollView(image: image)
    configScrollView()
  }
  
  @IBAction private func didTapBackButton() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func didTapSshareButton(_ sender: Any) {
    guard let image else { return }
    
    let objectsToShare: [Any] = [image]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    self.present(activityVC, animated: true, completion: nil)
  }
  
  private func configImageView() {
    guard let image, let imageView else { return }
    imageView.image = image
    imageView.frame.size = image.size
  }
  
  private func rescaleAndCenterImageInScrollView(image: UIImage?) {
    guard let scrollView, let image else { return }
    
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
    let newContentSize = scrollView.contentSize
    let x = (newContentSize.width - visibleRectSize.width) / 2
    let y = (newContentSize.height - visibleRectSize.height) / 2
    scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
  }
}

extension SingleImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    guard let imageView = imageView else { return }
    
    let boundsSize = scrollView.bounds.size
    let contentSize = scrollView.contentSize

    let offsetX = contentSize.width < boundsSize.width ? (boundsSize.width - contentSize.width) / 2 : 0.0
    
    let offsetY = contentSize.height < boundsSize.height ? (boundsSize.height - contentSize.height) / 2 : 0.0
    
    imageView.center = CGPoint(
      x: contentSize.width / 2 + offsetX,
      y: contentSize.height / 2 + offsetY
    )
  }
  
  private func configScrollView() {
    guard let scrollView else { return }
    
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 1.25
  }
}
