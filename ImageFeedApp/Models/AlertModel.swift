//
//  AlertModel.swift
//  ImageFeedApp
//
//  Created by Данил on 15/10/2026.
//

struct AlertButtonConfig {
    let title: String
    let handler: (() -> Void)?
}

struct AlertModel {
  let title: String
  let message: String
  let buttons: [AlertButtonConfig]
  
  static func getSimpleErrorAlertModel() -> AlertModel {
    .init(title: "Что-то пошло не так(",
          message: "Не удалось войти в систему",
          buttons: [AlertButtonConfig(title: "OK", handler: nil)])
  }
}
