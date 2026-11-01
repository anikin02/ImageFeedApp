//
//  Photo.swift
//  ImageFeedApp
//
//  Created by Данил on 01/11/2026.
//
@testable import ImageFeedApp
import Foundation

extension Photo {
  static func stub(
    id: String = "1",
    size: CGSize = CGSize(width: 100, height: 100),
    thumbImageURL: String = "",
    largeImageURL: String = "",
    isLiked: Bool = false
  ) -> Photo {
    Photo(
      id: id,
      size: size,
      createdAt: nil,
      welcomeDescription: nil,
      thumbImageURL: thumbImageURL,
      largeImageURL: largeImageURL,
      isLiked: isLiked
    )
  }
}
