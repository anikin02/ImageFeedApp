//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//
import UIKit

final class ProfileViewController: UIViewController {
  @IBOutlet weak private var profileImage: UIImageView?
  @IBOutlet weak private var nameLabel: UILabel?
  @IBOutlet weak private var loginLabel: UILabel?
  @IBOutlet weak private var descriptionLabel: UILabel?
  @IBOutlet weak private var exitButton: UIButton?
  
  @IBAction private func didTapExitButton(_ sender: Any) {
  }
  
}
