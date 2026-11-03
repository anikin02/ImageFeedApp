//
//  AlertPresenter.swift
//  ImageFeedApp
//
//  Created by Данил on 15/10/2026.
//
import UIKit

final class AlertPresenter {
  func show(in viewController: UIViewController, model: AlertModel) {
    let alert = UIAlertController(
      title: model.title,
      message: model.message,
      preferredStyle: .alert)
    
    alert.view.accessibilityIdentifier = AccessibilityIdentifiers.Alert.alert
    
    for button in model.buttons {
      let action = UIAlertAction(title: button.title, style: .default) { _ in
        button.handler?()
      }
      alert.addAction(action)
    }
    
    viewController.present(alert, animated: true, completion: nil)
  }
}
