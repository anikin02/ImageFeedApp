//
//  ISO8601DateFormatter.swift
//  ImageFeedApp
//
//  Created by Данил on 23/10/2026.
//
import Foundation

extension ISO8601DateFormatter {
  static let shared: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
}
