//
//  ProfileResult.swift
//  ImageFeedApp
//
//  Created by Данил on 12/10/2026.
//

struct ProfileResult: Codable {
  let username: String
  let firstName: String
  let lastName: String
  let bio: String?
  
  enum CodingKeys: String, CodingKey {
    case username
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
  }
}
