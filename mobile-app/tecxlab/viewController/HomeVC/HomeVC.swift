//
//  HomeVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 29/08/21.
//

import UIKit

class HomeVC: UIViewController {
    private var HomeListModel : HomeVCVM!
    
    @IBOutlet weak var tblList : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        self.navigationbarButtons()
        self.callToViewModelForUIUpdate()
    }
    
    func navigationbarButtons(){
        let sidemenubtn = UIBarButtonItem(image: UIImage(named: "side_menu"), style: .plain, target: self, action: #selector(SidemnuClick))
        navigationItem.leftBarButtonItems = [sidemenubtn]
    }
    
    @objc func SidemnuClick(){
        self.sideMenuController?.showLeftView()
    }
    
    func callToViewModelForUIUpdate(){
        SHOW_CUSTOM_LOADER()
        self.HomeListModel =  HomeVCVM()
        self.HomeListModel.bindHomeVCViewModelController = {
            DispatchQueue.main.async {
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
                HIDE_CUSTOM_LOADER()
            }
        }
    }
}


extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.HomeListModel.homeData.notification?.count ?? 0
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
        
        cell?.lblTitle.text = self.HomeListModel.homeData.notification?[indexPath.row].title ?? ""
        cell?.lblDate.text = self.HomeListModel.homeData.notification?[indexPath.row].time ?? ""
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}


//class NotificationListModel : NSObject{
//    var Response: String? = ""
//    var Motion_Detected: Int? = 0
//    var Unknowon_Detected: Int? = 0
//    var Data = NotificationListDataModel()
//    func initwith (dictionary : Dictionary<String,Any>){
//
//        if let _obj = dictionary["Response"] as? CVarArg{
//            self.Response = String(format: "%@", _obj)
//            if self.Response == "<null>"{
//                self.Response = ""
//            }
//        }
//        if let _obj = dictionary["Motion_Detected"] as? Int{
//            self.Motion_Detected = _obj
//        }
//        if let _obj = dictionary["Unknowon_Detected"] as? Int{
//            self.Unknowon_Detected = _obj
//        }
//        if let _obj = dictionary["Data"] as? Dictionary<String,Any>{
//            self.Data.initwith(dictionary: _obj)
//        }
//    }
//}
//class NotificationListDataModel : NSObject{
//    var notification: [NotificationListnotificationModel?] = []
//    func initwith (dictionary : Dictionary<String,Any>){
//        if let _obj = dictionary["notification"] as? [Any]{
//            for i in _obj{
//                let mymodel = NotificationListnotificationModel()
//                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
//                self.notification.append(mymodel)
//            }
//        }
//    }
//}
//class NotificationListnotificationModel : NSObject{
//    var title: String? = ""
//    var time: String? = ""
//    func initwith (dictionary : Dictionary<String,Any>){
//
//        if let _obj = dictionary["title"] as? String{
//            self.title = String(format: "%@", _obj)
//            if self.title == "<null>"{
//                self.title = ""
//            }
//        }
//        if let _obj = dictionary["time"] as? String{
//            self.time = String(format: "%@", _obj)
//            if self.time == "<null>"{
//                self.time = ""
//            }
//        }
//    }
//}

