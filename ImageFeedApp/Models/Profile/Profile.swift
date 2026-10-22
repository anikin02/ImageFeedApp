//
//  Profile.swift
//  ImageFeedApp
//
//  Created by Данил on 12/10/2026.
//

struct Profile {
  let name: String
  let loginName: String
  let username: String
  let bio: String?
  
  init(from profileResult: ProfileResult) {
    self.loginName = "@\(profileResult.username)"
    self.username = profileResult.username
    self.name = "\(profileResult.firstName) \(profileResult.lastName)"
    self.bio = profileResult.bio
  }
}
