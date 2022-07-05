//
//  ContactDetailVM.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

import Foundation


class ContactDetailVM : NSObject{
    private var apiService : APIService!
    
    private(set) var contactDetailData : FaceDetailModel!{
        didSet{
            self.bindContactDetailViewModelController()
        }
    }
    
    var bindContactDetailViewModelController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    init(groupName: String) {
        super.init()
        self.apiService =  APIService()
        self.callFunctionToGetEmpData(fullname: groupName)
    }
    
    func callFunctionToGetEmpData(fullname : String){
        let dictParam = NSMutableDictionary()
        dictParam.setValue("\(fullname)", forKey: "fullname")
        self.apiService.apiToGetContactDetailData(param: dictParam as! [String : Any]) { (contactData) in
            print(contactData)
            self.contactDetailData = contactData
        }
    }
}
