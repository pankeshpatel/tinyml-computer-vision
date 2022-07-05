//
//  VideoGalleryVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 05/09/21.
//

import UIKit
import AVFoundation
import AVKit

class VideoGalleryVC: UIViewController {
    private var videoGalleryvm : VideoGalleryVM!
    var dictVideoGalley = VideoGalleryListModel()
    @IBOutlet weak var tblList : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationbarButtons()
        self.navigationItem.title = "Video Gallery"
//        self.getNotifications()
        self.callToViewModelForUIUpdate()
        // Do any additional setup after loading the view.
    }
    
    
    func callToViewModelForUIUpdate(){
        self.videoGalleryvm =  VideoGalleryVM()
        self.videoGalleryvm.bindVideoGalleryViewModelController = {
                DispatchQueue.main.async {
                    self.tblList.delegate = self
                    self.tblList.dataSource = self
                    self.tblList.reloadData()
                }
            }
        }
    
    func navigationbarButtons(){
        let sidemenubtn = UIBarButtonItem(image: UIImage(named: "side_menu"), style: .plain, target: self, action: #selector(SidemnuClick))
        navigationItem.leftBarButtonItems = [sidemenubtn]
    }
    
    @objc func SidemnuClick(){
        self.sideMenuController?.showLeftView()
    }
    
}


extension VideoGalleryVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoGalleryvm.videoGalleryData.notification?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NotificationCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NotificationCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("NotificationCell", owner: self, options: nil)
            cell = nib?[0] as? NotificationCell
        }
        cell?.layer.shouldRasterize = true
        cell?.layer.rasterizationScale = UIScreen.main.scale
        cell?.selectionStyle = .none
        
        cell?.lblTitle.text = self.videoGalleryvm.videoGalleryData.notification?[indexPath.row].title ?? ""
        cell?.lblDate.text = self.videoGalleryvm.videoGalleryData.notification?[indexPath.row].time ?? ""
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let videoURL = URL(string: self.videoGalleryvm.videoGalleryData.notification?[indexPath.row].video ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

class VideoGalleryListModel : NSObject{
    var statusCode : Int? = 0
    var Data = VideoGalleryListDataModel()
    func initwith (dictionary : Dictionary<String,Any>){
        if let _obj = dictionary["statusCode"] as? Int{
            self.statusCode = _obj
        }
        if let _obj = dictionary["Data"] as? Dictionary<String,Any>{
            self.Data.initwith(dictionary: _obj)
        }
    }
}
class VideoGalleryListDataModel : NSObject{
    var notification: [VideoGalleryListnotificationModel?] = []
    func initwith (dictionary : Dictionary<String,Any>){
        if let _obj = dictionary["notification"] as? [Any]{
            for i in _obj{
                let mymodel = VideoGalleryListnotificationModel()
                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
                self.notification.append(mymodel)
            }
        }
    }
}
class VideoGalleryListnotificationModel : NSObject{
    var title: String? = ""
    var time: String? = ""
    var video: String? = ""
    func initwith (dictionary : Dictionary<String,Any>){
        
        if let _obj = dictionary["title"] as? String{
            self.title = String(format: "%@", _obj)
            if self.title == "<null>"{
                self.title = ""
            }
        }
        if let _obj = dictionary["time"] as? String{
            self.time = String(format: "%@", _obj)
            if self.time == "<null>"{
                self.time = ""
            }
        }
        if let _obj = dictionary["video"] as? String{
            self.video = String(format: "%@", _obj)
            if self.video == "<null>"{
                self.video = ""
            }
        }
    }
}

