//
//  ContactDetailModel.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let faceDetailModel = try? newJSONDecoder().decode(FaceDetailModel.self, from: jsonData)


// MARK: - FaceDetailModel
struct FaceDetailModel: Codable {
    let statusCode: Int?
    let response: String?
    let body: Body?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case response = "Response"
        case body
    }
}

// MARK: - Body
struct Body: Codable {
    let fullname, emailID, group, phone: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case fullname
        case emailID = "emailId"
        case group, phone, img
    }
}
