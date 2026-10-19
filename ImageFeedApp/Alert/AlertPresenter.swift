//
//  AlertPresenter.swift
//  ImageFeedApp
//
//  Created by Данил on 15/10/2026.
//
import UIKit

final class AlertPresenter {
  private static let alertAccessibilityIdentifier = "Alert"
  
  func show(in viewController: UIViewController, model: AlertModel) {
    let alert = UIAlertController(
      title: model.title,
      message: model.message,
      preferredStyle: .alert)
    
    alert.view.accessibilityIdentifier = Self.alertAccessibilityIdentifier
    
    let action = UIAlertAction(title: model.buttonText, style: .default, handler: nil)
    
    alert.addAction(action)
    
    viewController.present(alert, animated: true, completion: nil)
  }
}
