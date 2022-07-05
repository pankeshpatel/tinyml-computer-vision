//
//  ContactListVM.swift
//  tecxlab
//
//  Created by bhavin joshi on 09/05/22.
//

import Foundation

class ContactListVM : NSObject{
    private var apiService : APIService!
    
    private(set) var contactData : ContactListModel!{
        didSet{
            self.bindContactListViewModelController()
        }
    }
    
    private(set) var deleteData : DeleteFaceModel!{
        didSet{
            self.bindContactDeleteViewModelController()
        }
    }
    
    var bindContactListViewModelController : (() -> ()) = {}
    var bindContactDeleteViewModelController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    init(groupName: String) {
        super.init()
        self.apiService =  APIService()
        self.callFunctionToGetEmpData(group_type: groupName)
    }
    
    init(fullname : String, isDelete : Bool){
        super.init()
        self.apiService = APIService()
        self.callDeleteContact(fullname: fullname)
    }
    
    func callDeleteContact(fullname : String){
        let dictParam = NSMutableDictionary()
        dictParam.setValue(fullname, forKey: "fullname")
        self.apiService.apiToDeleteContactData(param: dictParam as! [String : Any]) { (contactData) in
            print(contactData)
            self.deleteData = contactData
        }
    }
    
    func callFunctionToGetEmpData(group_type : String){
        let dictParam = NSMutableDictionary()
        dictParam.setValue("\(group_type)", forKey: "group")
        self.apiService.apiToGetContactData(param: dictParam as! [String : Any]) { (contactData) in
            print(contactData)
            self.contactData = contactData
        }
    }
}
