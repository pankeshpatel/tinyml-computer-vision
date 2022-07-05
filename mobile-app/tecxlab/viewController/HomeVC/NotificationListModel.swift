//
//  NotificationListModel.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notificationListModel = try? newJSONDecoder().decode(NotificationListModel.self, from: jsonData)

import Foundation

// MARK: - NotificationListModel
struct NotificationListModel: Codable {
    let notification: [Notification]?
}

// MARK: - Notification
struct Notification: Codable {
    let title, time: String?
    let video: String?
}
