//
//  VideoGalleryVM.swift
//  tecxlab
//
//  Created by bhavin joshi on 10/05/22.
//

import Foundation


class VideoGalleryVM : NSObject{
    private var apiService : APIService!
    
    private(set) var videoGalleryData : NotificationListModel!{
        didSet{
            self.bindVideoGalleryViewModelController()
        }
    }
    
    var bindVideoGalleryViewModelController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService = APIService()
        self.callFunctionToGetVideoGalleryData()
    }

    func callFunctionToGetVideoGalleryData(){
        self.apiService.apiToGetVideoGallery {
            (homeData) in
            self.videoGalleryData = homeData
        }
    }
}
