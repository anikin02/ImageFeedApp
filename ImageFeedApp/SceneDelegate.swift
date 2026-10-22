//
//  SceneDelegate.swift
//  ImageFeedApp
//
//  Created by Данил on 30/09/2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let scene = scene as? UIWindowScene else { return }
      window = UIWindow(windowScene: scene)
      window?.rootViewController = SplashViewController()
      window?.makeKeyAndVisible()
  }
}

