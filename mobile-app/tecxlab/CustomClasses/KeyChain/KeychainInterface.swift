//
//  KeychainInterface.swift
//  tecxlab
//
//  Created by bhavin joshi on 06/05/22.
//

import Foundation
import Security

class KeychainInterface{
    
    typealias CompletionHandler = (_ success:Bool, _ Message: String) -> Void
    
    enum KeychainError: Error{
        //Attempt to read an item that does not exist
        case itemNotFound
        
        //Attempt save to override an exsting item.
        //Use update instead od save to update existing items
        case duplicateItem
        
        //A read of an item in any format than Data
        case invalidItemFormat
        
        //Any operation result status than errSecSuccess
        case unexpectedStatus(OSStatus)
    }
    
    //MARK: save data in keychain after Login
    static func saveLoginData(password: String, service: String, account: String ,authToken: String, completionHandler: @escaping CompletionHandler){
        
        let query: [String: Any] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess{
            completionHandler(true,"Added to Keychain")
        }
        else  if status == errSecDuplicateItem {
            completionHandler(false,"Dublicate Data Found")
        }
        else {
            completionHandler(false,"Unexpected Error Found")
        }
    }
    
}
