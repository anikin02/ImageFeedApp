//
//  TabBarController.swift
//  ImageFeedApp
//
//  Created by Данил on 19/10/2026.
//

import UIKit

final class TabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTabBarItems()
    
    tabBar.tintColor = .ypWhiteIOS
  }
  
  private func setupTabBarItems() {
    let imagesListViewController = ImagesListViewController()

    imagesListViewController.tabBarItem = UITabBarItem(
      title: "",
      image: UIImage(named: "tab_editorial_active"),
      selectedImage: nil
    )
    
    let profileViewController = ProfileViewController()
    
    profileViewController.tabBarItem = UITabBarItem(
      title: "",
      image: UIImage(named: "tab_profile_active"),
      selectedImage: nil
    )
    
    self.viewControllers = [imagesListViewController, profileViewController]
  }
}
