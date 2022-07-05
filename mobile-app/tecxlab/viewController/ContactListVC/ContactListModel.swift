//
//  ContactListModel.swift
//  tecxlab
//
//  Created by bhavin joshi on 09/05/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let contactListModel = try? newJSONDecoder().decode(ContactListModel.self, from: jsonData)

import Foundation

// MARK: - ContactListModel
struct ContactListModel: Codable {
    let statusCode: Int?
    let data: [Contact_Data]?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data = "Data"
    }
}

// MARK: - Datum
struct Contact_Data: Codable {
    let emailID, group, fullname, phone: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case emailID = "emailId"
        case group, fullname, phone, img
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let deleteFaceModel = try? newJSONDecoder().decode(DeleteFaceModel.self, from: jsonData)

//import Foundation

// MARK: - DeleteFaceModel
struct DeleteFaceModel: Codable {
    let statusCode: Int?
    let body: Delete_Face_Body?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct Delete_Face_Body: Codable {
    let response: String?

    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }
}

