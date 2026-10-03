//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//
import UIKit

final class ProfileViewController: UIViewController {
  // MARK: - Properties
  private var profileImage: UIImageView = .init()
  private var nameLabel: UILabel = .init()
  private var loginLabel: UILabel = .init()
  private var descriptionLabel: UILabel = .init()
  private var exitButton: UIButton = .init()
  
  // MARK: - Lyfecycle
  override func viewDidLoad() {
    configUI()
  }
  
  // MARK: - Private Methods
  private func configUI() {
    configProfileImage()
    configNameLabel()
    configLoginLabel()
    configDescriptionLabel()
    configExitButton()
  }
  
  private func configProfileImage() {
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    profileImage.image = UIImage(named: "profile_pic")
    
    view.addSubview(profileImage)
    
    NSLayoutConstraint.activate([
      profileImage.widthAnchor.constraint(equalToConstant: 70),
      profileImage.heightAnchor.constraint(equalToConstant: 70),
      profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
    ])
  }
  
  private func configNameLabel() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.text = "Екатерина Новикова"
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    nameLabel.textColor = .ypWhiteIOS
    
    view.addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  private func configLoginLabel() {
    loginLabel.translatesAutoresizingMaskIntoConstraints = false
    loginLabel.text = "@ekaterina_nov"
    loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    loginLabel.textColor = .ypGrayIOS
    
    view.addSubview(loginLabel)
    
    NSLayoutConstraint.activate([
      loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  private func configDescriptionLabel() {
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.text = "Hello, world!"
    descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    descriptionLabel.textColor = .ypWhiteIOS
    
    view.addSubview(descriptionLabel)
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  private func configExitButton() {
    exitButton.translatesAutoresizingMaskIntoConstraints = false
    exitButton.setImage(UIImage(named: "Exit"), for: .normal)
    
    view.addSubview(exitButton)
    
    NSLayoutConstraint.activate([
      exitButton.widthAnchor.constraint(equalToConstant: 44),
      exitButton.heightAnchor.constraint(equalToConstant: 44),
      exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
      exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }
}
