//
//  Constants.swift
//  tecxlab
//
//  Created by bhavin joshi on 26/08/21.
//

import Foundation
import AWSCore
import AWSCognito

let CognitoIdentityUserPoolRegion: AWSRegionType = .USEast1
let CognitoIdentityUserPoolId = "us-east-1_ToGmPYS0L"
let CognitoIdentityUserPoolAppClientId = "3c9tkvnniu8737ikd5ghk6eo1r"
let CognitoIdentityUserPoolAppClientSecret = "k2h7807ngojshtenjcoc38a3ig2k6nk66aoes7bne6vfbkopn5c"
let AWSCognitoUserPoolsSignInProviderKey = "SmartDoorbellUsers"


class Constants {
    //public static let AppColor = (UIColor(red: 231.0/255.0, green: 39.0/255.0, blue: 45.0/255.0, alpha: 1.0))
    
    public static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public static let USERDEFAULTS = UserDefaults.standard
    public static let navigationcontroller = UINavigationController()
    
    //Production Server
    public static let BaseUrl = "http://44.240.240.55:8000/"

    public static let ImageBaseUrl = "http://44.240.240.55:8000/"
    
    
    
    public static let Token = "token"
    public static let get_data_on_group = "get-data-on-group"
    public static let get_all_video_details = "get-all-video-details"
    public static let get_face_details = "get-face-details"
    public static let edit_contact = "edit-contact"
    public static let add_face = "add-face"
    public static let delete_face = "delete-face"
    
    
    public static let getNotification = "get-notifications"
    public static let get_group_info = "get-group-info"
    //public static let get_face_details = "get-face-details"
    public static let edit_profile = "edit-profile"
    public static let register_face = "register-face"
    
    public static let get_notification_video = "get-notification-video"
    public static let get_notification_by_type = "get-notification-by-type"
    
    
    //--------
    
    public static let key128   = "@#$&+=@#$%*?~#$%"                   // 16 bytes for AES128
    public static let key256   = "@C#@#IOS$&$sp&+=L@#d$%*T?~#$%eeA"   // 32 bytes for AES256
    public static let iv       = "omniteamcltspeed"                   // 16 bytes for AES128

    
    public static let NetworkUnavailable = "Please Check your Internet Connection"
    public static let device_type = "2" // iOS = 2

    
}

