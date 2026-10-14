//
//  UIBlockingProgressHUD.swift
//  ImageFeedApp
//
//  Created by Данил on 12/10/2026.
//

import ProgressHUD
import UIKit

final class UIBlockingProgressHUD {
  private static var window: UIWindow? {
    return UIApplication.shared.connectedScenes
    //      .compactMap { $0 as? UIWindowScene }
    //      .first { $0.activationState == .foregroundActive }?
    //      .windows
    //      .first { $0.isKeyWindow }
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
  
  static func show() {
    window?.isUserInteractionEnabled = false
    ProgressHUD.animate()
  }
  
  static func dismiss() {
    window?.isUserInteractionEnabled = true
    ProgressHUD.dismiss()
  }
}
