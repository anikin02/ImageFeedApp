//
//  ProfileImageServiceSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 30/10/2026.
//

@testable import ImageFeedApp
import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
  var profileImage: ProfileImage?
  
  init() {
    self.profileImage = ProfileImage(small: "https://dzen.ru",
                                     medium: "https://dzen.ru",
                                     large: "https://dzen.ru")
  }
  
  func fetchProfileImageURL(_ username: String, completion: @escaping (Result<ProfileImage, Error>) -> Void) {}
  
  func logout() {}
}
