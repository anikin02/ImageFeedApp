//
//  ProfileImage.swift
//  ImageFeedApp
//
//  Created by Данил on 14/10/2026.
//

struct ProfileImage: Codable {
  let small: String
  let medium: String
  let large: String
}

struct UserResult: Codable {
  let profile_image: ProfileImage
}
