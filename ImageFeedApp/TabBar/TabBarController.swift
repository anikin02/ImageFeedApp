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
    let imagesListPresenter = ImagesListPresenter()
    imagesListViewController.presenter = imagesListPresenter
    imagesListPresenter.view = imagesListViewController

    imagesListViewController.tabBarItem = UITabBarItem(
      title: "",
      image: UIImage(named: "tab_editorial_active"),
      selectedImage: nil
    )
    
    let profileViewController = ProfileViewController()
    let profilePresenter = ProfilePresenter()
    profileViewController.presenter = profilePresenter
    profilePresenter.view = profileViewController
    
    profileViewController.tabBarItem = UITabBarItem(
      title: "",
      image: UIImage(named: "tab_profile_active"),
      selectedImage: nil
    )
    
    self.viewControllers = [imagesListViewController, profileViewController]
  }
}
