//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Данил on 02/10/2026.
//
import UIKit
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
  var presenter: ProfilePresenterProtocol? { get set }
  
  func showProfile(profile: Profile)
  func showAvatar(url: URL)
  func showAlertExitWarning()
  func switchToSplashViewController()
}

final class ProfileViewController: UIViewController & ProfileViewProtocol {
  // MARK: - Properties
  var presenter: ProfilePresenterProtocol?
  
  private var profileImage: UIImageView = .init()
  private var nameLabel: UILabel = .init()
  private var loginLabel: UILabel = .init()
  private var descriptionLabel: UILabel = .init()
  private var exitButton: UIButton = .init()
  
  private var alertPresenter: AlertPresenter = .init()
  
  // MARK: - Lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI()
    presenter?.viewDidLoad()
  }
  
  // MARK: - ProfileViewProtocol
  func switchToSplashViewController() {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    
    let splashVC = SplashViewController()
    
    window?.rootViewController = splashVC
  }
  
  func showAlertExitWarning() {
    let alertModel = AlertModel(title: "Пока, пока!",
                                message: "Уверены, что хотите выйти?",
                                buttons: [AlertButtonConfig(title: "Да", handler: presenter?.didConfirmLogout),
                                          AlertButtonConfig(title: "Нет", handler: nil)])
    alertPresenter.show(in: self, model: alertModel)
  }
  
  func showProfile(profile: Profile) {
    nameLabel.text = profile.name
    loginLabel.text = profile.loginName
    descriptionLabel.text = profile.bio
  }
  
  func showAvatar(url: URL) {
    profileImage.kf.setImage(with: url)
  }
  
  // MARK: - Private Methods
  
  private func configUI() {
    view.backgroundColor = .ypBlackIOS
    
    configProfileImage()
    configNameLabel()
    configLoginLabel()
    configDescriptionLabel()
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
  
  private func configNameLabel() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
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
    presenter?.didTapExit()
  }
}
