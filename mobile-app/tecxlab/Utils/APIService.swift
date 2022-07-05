//
//  APIService.swift
//  tecxlab
//
//  Created by bhavin joshi on 09/05/22.
//

import Foundation
import LGSideMenuController

class APIService : NSObject{
    
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    private let sourcesURL = URL(string: "\(Constants.BaseUrl)\(Constants.get_data_on_group)")
    
    func apiToGetContactData(param : [String : Any], completion : @escaping (ContactListModel) -> ()){
        let postData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.get_data_on_group)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "POST"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(ContactListModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
    func apiToGetHomeData(completion : @escaping (NotificationListModel) -> ()){
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.get_all_video_details)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "GET"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(NotificationListModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
    func apiToGetVideoGallery(completion : @escaping (NotificationListModel) -> ()){
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.get_all_video_details)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "GET"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(NotificationListModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
    func apiToGetContactDetailData(param : [String : Any], completion : @escaping (FaceDetailModel) -> ()){
        let postData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.get_face_details)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "POST"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(FaceDetailModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
    
    func apiToEditContactData(param : [String : Any], completion : @escaping (AddEditContactModel) -> ()){
        let postData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.edit_contact)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "POST"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(AddEditContactModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
    func apiToAddFaceData(param : [String : Any], completion : @escaping (AddEditContactModel) -> ()){
        let postData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.add_face)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "POST"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(AddEditContactModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
    func apiToDeleteContactData(param : [String : Any], completion : @escaping (DeleteFaceModel) -> ()){
        let postData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let urlData = URL(string: "\(Constants.BaseUrl)\(Constants.delete_face)")
        var request = URLRequest(url: urlData!)
        request.httpMethod = "POST"
        
        let headers = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "authorization": "Bearer \(Constants.USERDEFAULTS.value(forKey: "access_token") as? String ?? "")",
        ]
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(DeleteFaceModel.self, from: data)
                completion(empData)
            }
        }.resume()
    }
    
}
