//
//  Photo.swift
//  ImageFeedApp
//
//  Created by Данил on 23/10/2026.
//
import Foundation

struct Photo {
  let id: String
  let size: CGSize
  let createdAt: Date?
  let welcomeDescription: String?
  let thumbImageURL: String
  let largeImageURL: String
  let isLiked: Bool
  
  init (id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
    self.id = id
    self.size = size
    self.createdAt = createdAt
    self.welcomeDescription = welcomeDescription
    self.thumbImageURL = thumbImageURL
    self.largeImageURL = largeImageURL
    self.isLiked = isLiked
  }
  
  init(result: PhotoResult) {
    id = result.id
    size = CGSize(width: CGFloat(result.width), height: CGFloat(result.height))
    welcomeDescription = result.description
    thumbImageURL = result.urls.thumb
    largeImageURL = result.urls.full
    isLiked = result.likedByUser
    
    if let dateString = result.createdAt {
      self.createdAt = ISO8601DateFormatter.shared.date(from: dateString)
    } else {
      self.createdAt = nil
    }
  }
  
  init(oldPhoto: Photo) {
    self.id = oldPhoto.id
    self.size = oldPhoto.size
    self.createdAt = oldPhoto.createdAt
    self.welcomeDescription = oldPhoto.welcomeDescription
    self.thumbImageURL = oldPhoto.thumbImageURL
    self.largeImageURL = oldPhoto.largeImageURL
    self.isLiked = !oldPhoto.isLiked
  }
  
}
