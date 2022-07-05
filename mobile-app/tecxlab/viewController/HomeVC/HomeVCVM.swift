//
//  HomeVCVM.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

import Foundation


class HomeVCVM : NSObject{
    private var apiService : APIService!
    
    private(set) var homeData : NotificationListModel!{
        didSet{
            self.bindHomeVCViewModelController()
        }
    }
    
    var bindHomeVCViewModelController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
        self.callFunctionToGetHomeData()
    }

    func callFunctionToGetHomeData(){
        self.apiService.apiToGetHomeData {
            (homeData) in
            print(homeData)
            self.homeData = homeData
        }
    }
}
