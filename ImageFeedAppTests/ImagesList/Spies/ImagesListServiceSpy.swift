//
//  ImagesListServiceSpy.swift
//  ImageFeedApp
//
//  Created by Данил on 01/11/2026.
//
@testable import ImageFeedApp
import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
  var photos: [Photo] = []
  var fetchPhotosNextPageCallsCount = 0
  var changeLikeArguments: (id: String, isLike: Bool)?
  var changeLikeCalled = false
  
  func fetchPhotosNextPage() {
    fetchPhotosNextPageCallsCount += 1
  }
  
  func logout() {}
  
  func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void
  ) {
    changeLikeCalled = true
  }
}
