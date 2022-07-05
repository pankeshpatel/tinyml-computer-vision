//
//  AddEditContactModel.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addEditContactModel = try? newJSONDecoder().decode(AddEditContactModel.self, from: jsonData)

import Foundation

// MARK: - AddEditContactModel
struct AddEditContactModel: Codable {
    let statusCode: Int?
    let body: AddEditContactModelBody?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body, message
    }
}

// MARK: - Body
struct AddEditContactModelBody: Codable {
    let fullname, phone, group, emailID: String?

    enum CodingKeys: String, CodingKey {
        case fullname, phone, group
        case emailID = "emailId"
    }
}
