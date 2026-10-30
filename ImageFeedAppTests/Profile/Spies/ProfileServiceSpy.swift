//
//  ProfileServiceSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 29/10/2026.
//
@testable import ImageFeedApp
import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
  var profile: Profile?
  
  init() {
    profile = .init(name: "", loginName: "", username: "", bio: "")
  }
  
  func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeedApp.Profile, any Error>) -> Void) {}
  
  func logout() {}
}
