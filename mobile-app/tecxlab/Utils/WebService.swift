//
//  WebService.swift
//  CLT Speed
//
//  Created by Sanskar Management Pro on 05/01/21.
//

import UIKit
import Alamofire

class WebService: NSObject {
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    
    class func postToken(params: [String : AnyObject], apikey: String, completion: @escaping (Any) -> Void, failure:@escaping (Error) -> Void)
    {
        
        if !Reachability.isConnectedToNetwork(){
            //Constants.appDelegate.NoInternetDialog()
        }

        let strURL = "\(Constants.BaseUrl)\(apikey)"
        let url = URL(string: strURL)
        
        var request = URLRequest(url: url!)
        request.timeoutInterval = 60
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "content-type": "application/x-www-form-urlencoded",
            "accept": "application/json",
            "cache-control": "no-cache",
          ]
        
        let postData = NSMutableData(data: "username=arya".data(using: String.Encoding.utf8)!)
        postData.append("&password=secret".data(using: String.Encoding.utf8)!)
        
        request.httpBody = postData as Data
        var dataTask: URLSessionDataTask? = nil
        dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            var dictonary:NSDictionary?
            
            if (error as? URLError)?.code == .timedOut {
                let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Server Request Time Out"])
                failure(error)
            }
            else{
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    if let myDictionary = dictonary
                    {
                        print(myDictionary)
                        completion(myDictionary)
                    }
                    
                } catch let error as NSError {
                    let response = response as! HTTPURLResponse
                    if response.statusCode == 401{
                        //Constants.appDelegate.logoutAlert()
                        //HIDE_CUSTOM_LOADER()
                        //Constants.appDelegate.SessionExpireDialog()
                    }
                    else{
                        failure(error)
                    }
                }
            }
        })
        dataTask?.resume()
    }
    
    
    class func GetMethod (params: [String : AnyObject], apikey: String, completion: @escaping (Any) -> Void, failure:@escaping (Error) -> Void)
    {
        //NotificationCenter.default.post(name: Notification.Name("stopAutoUpdate"), object: nil)
        if !Reachability.isConnectedToNetwork(){
            //Constants.appDelegate.NoInternetDialog()
        }
        print("//---- \n\n API : \(apikey) \n\n //-----\n\n Param : \(params) \n\n")
        let APIKEYurlString = apikey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let strURL =  "\(Constants.BaseUrl)\(APIKEYurlString)"
        
        
        let url = URL(string: strURL)
        
        
        print("get url : \(String(describing: url))")
        let authtoken = Constants.USERDEFAULTS.value(forKey: "authtoken") as? String ?? ""
        let userid = Constants.USERDEFAULTS.value(forKey: "userid") as? String ?? ""
        let tenantId = Constants.USERDEFAULTS.value(forKey: "tenantId") as? String ?? ""
        let token = Constants.USERDEFAULTS.value(forKey: "token") as? String ?? ""
        
        let headers : HTTPHeaders =  [
            "Content-Type": "application/json",
            "DeviceType": Constants.device_type,
            "DeviceToken": token,
            "DeviceId":UIDevice.current.identifierForVendor?.uuidString ?? "",
            "Authorization" : "Bearer \(authtoken)",
            "UserId" : "\(userid)",
            "X-TENANT-ID" : "\(tenantId)"
        ]
        
        print("--headers : \(headers)")
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(url!, method: .get, parameters: params,headers: nil)
            .responseJSON
            {
                response in
                switch (response.result)
                {
                case .success:
                    
                    let jsonResponse = response.value as! NSDictionary
                    print("//------\n\n Response \(apikey) : \(jsonResponse) \n\n")
                    completion(jsonResponse)
                    
                case .failure( _):
                    
                    let error = NSError(domain:"", code:response.response?.statusCode ?? 0, userInfo:[ NSLocalizedDescriptionKey: response.error?.errorDescription ?? "Something Went Wrong. Please Try Again Later."])
                    if response.response?.statusCode ?? 0 == 401{
                        //Constants.appDelegate.logoutAlert()
                        //HIDE_CUSTOM_LOADER()
                        //Constants.appDelegate.SessionExpireDialog()
                    }
                    else{
                        failure(error)
                    }
                    //print("API Error : \(String(describing: response.response?.statusCode) ) \n\n")
                    break
                }
            }
    }
    
    class func GetCountMethod (params: [String : AnyObject], apikey: String, completion: @escaping (Any) -> Void, failure:@escaping (Error) -> Void)
    {
        if !Reachability.isConnectedToNetwork(){
            //Constants.appDelegate.NoInternetDialog()
        }
        print("//---- \n\n API : \(apikey) \n\n //-----\n\n Param : \(params) \n\n")
        let APIKEYurlString = apikey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let strURL =  "\(Constants.USERDEFAULTS.value(forKey: "BaseUrl") as? String ?? "")\(APIKEYurlString)"
        
        
        let url = URL(string: strURL)
        
        
        print("get url : \(String(describing: url))")
        let authtoken = Constants.USERDEFAULTS.value(forKey: "authtoken") as? String ?? ""
        let userid = Constants.USERDEFAULTS.value(forKey: "userid") as? String ?? ""
        let tenantId = Constants.USERDEFAULTS.value(forKey: "tenantId") as? String ?? ""
        let token = Constants.USERDEFAULTS.value(forKey: "token") as? String ?? ""
        
        let headers : HTTPHeaders =  [
            "Content-Type": "application/json",
            "DeviceType": Constants.device_type,
            "DeviceToken": token,
            "DeviceId":UIDevice.current.identifierForVendor?.uuidString ?? "",
            "Authorization" : "Bearer \(authtoken)",
            "UserId" : "\(userid)",
            "X-TENANT-ID" : "\(tenantId)"
        ]
        
        print("--headers : \(headers)")
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(url!, method: .get, parameters: params,headers: headers)
            .responseJSON
            {
                response in
                switch (response.result)
                {
                case .success:
                    
                    let jsonResponse = response.value as! NSDictionary
                    print("//------\n\n Response \(apikey) : \(jsonResponse) \n\n")
                    completion(jsonResponse)
                    
                case .failure( _):
                    
                    let error = NSError(domain:"", code:response.response?.statusCode ?? 0, userInfo:[ NSLocalizedDescriptionKey: response.error?.errorDescription ?? "Something Went Wrong. Please Try Again Later."])
                    if response.response?.statusCode ?? 0 == 401{
                        //Constants.appDelegate.logoutAlert()
                        //HIDE_CUSTOM_LOADER()
                        //Constants.appDelegate.SessionExpireDialog()
                    }
                    else{
                        failure(error)
                    }
                    //print("API Error : \(String(describing: response.response?.statusCode) ) \n\n")
                    break
                }
            }
    }
    
}
