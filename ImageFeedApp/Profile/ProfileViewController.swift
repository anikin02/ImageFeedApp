//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
  // MARK: - Properties
  private var profileImage: UIImageView = .init()
  private var nameLabel: UILabel = .init()
  private var loginLabel: UILabel = .init()
  private var descriptionLabel: UILabel = .init()
  private var exitButton: UIButton = .init()
  
  private var profileImageServiceObserver: NSObjectProtocol?
  
  private let profileService: ProfileService = .shared
  private let logoutService: ProfileLogoutService = .shared
  
  // MARK: - Lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI(profile: profileService.profile)
    
    profileImageServiceObserver = NotificationCenter.default
      .addObserver(
        forName: ProfileImageService.didChangeNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        guard let self = self else { return }
        self.updateProfileImage()
      }
    
    updateProfileImage()
  }
  
  // MARK: - Private Methods
  private func updateProfileImage() {
    guard
      let profileImageURL = ProfileImageService.shared.profileImage?.small,
      let url = URL(string: profileImageURL)
    else {
      return }
    
    profileImage.kf.setImage(with: url)
  }
  
  private func configUI(profile: Profile?) {
    view.backgroundColor = .ypBlackIOS
    
    guard let profile else { return }
    
    configProfileImage()
    configNameLabel(with: profile.name)
    configLoginLabel(with: profile.loginName)
    configDescriptionLabel(with: profile.bio)
    configExitButton()
  }
  
  private func configProfileImage() {
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(profileImage)
    
    NSLayoutConstraint.activate([
      profileImage.widthAnchor.constraint(equalToConstant: 70),
      profileImage.heightAnchor.constraint(equalToConstant: 70),
      profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
    ])
    
    profileImage.layer.cornerRadius = 35
    profileImage.layer.masksToBounds = true
  }
  
  private func configNameLabel(with name: String) {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.text = name
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    nameLabel.textColor = .ypWhiteIOS
    
    view.addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  private func configLoginLabel(with login: String) {
    loginLabel.translatesAutoresizingMaskIntoConstraints = false
    loginLabel.text = login
    loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    loginLabel.textColor = .ypGrayIOS
    
    view.addSubview(loginLabel)
    
    NSLayoutConstraint.activate([
      loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  private func configDescriptionLabel(with bio: String?) {
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.text = bio ?? "Отсутствует описание"
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
    exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    view.addSubview(exitButton)
    
    NSLayoutConstraint.activate([
      exitButton.widthAnchor.constraint(equalToConstant: 44),
      exitButton.heightAnchor.constraint(equalToConstant: 44),
      exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
      exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }
  
  @objc private func didTapExitButton() {
    logoutService.logout()
    switchToSplashViewController()
  }
  
  private func switchToSplashViewController() {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    
    let splashVC = SplashViewController()
    
    window?.rootViewController = splashVC
  }
}
