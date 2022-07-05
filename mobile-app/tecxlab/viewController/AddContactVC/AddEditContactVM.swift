//
//  AddEditContactVM.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

import Foundation


class AddEditContactVM : NSObject{
    private var apiService : APIService!
    
    private(set) var AddFaceDetail : AddEditContactModel!{
        didSet{
            self.bindAddFaceDetailViewModelController()
        }
    }
    var bindAddFaceDetailViewModelController : (() -> ()) = {}
    
    private(set) var EditFaceDetail : AddEditContactModel!{
        didSet{
            self.bindEditFaceDetailViewModelController()
        }
    }
    var bindEditFaceDetailViewModelController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    init(EditFaceParam: [String : Any]) {
        super.init()
        self.apiService =  APIService()
        self.callApiEditFace(param: EditFaceParam)
    }
    
    init(AddFaceParam: [String : Any]) {
        super.init()
        self.apiService =  APIService()
        self.callFunctionToAddFace(param: AddFaceParam)
    }
    
    func callFunctionToAddFace(param : [String : Any]){
        self.apiService.apiToAddFaceData(param: param) { (AddFaceResponse) in
            self.AddFaceDetail = AddFaceResponse
        }
    }
    
    func callApiEditFace(param : [String : Any]){
        self.apiService.apiToEditContactData(param: param) { (EditFaceResponse) in
            self.EditFaceDetail = EditFaceResponse
        }
    }
}
