//
//  StatisticVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 06/09/21.
//

import UIKit

class StatisticVC: UIViewController {
    @IBOutlet weak var btnMissed : UIButton!
    @IBOutlet weak var btnMotion : UIButton!
    @IBOutlet weak var btnUnknow : UIButton!
    
    var dictStatistic = StatisticListModel()
    @IBOutlet weak var tblList : UITableView!
    var intSelectedOption = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationbarButtons()
        self.navigationItem.title = "Statistics"
        self.btnMissedClick(self)
        // Do any additional setup after loading the view.
    }
   
    func navigationbarButtons(){
        let sidemenubtn = UIBarButtonItem(image: UIImage(named: "side_menu"), style: .plain, target: self, action: #selector(SidemnuClick))
        navigationItem.leftBarButtonItems = [sidemenubtn]
    }
    
    @objc func SidemnuClick(){
        self.sideMenuController?.showLeftView()
    }
    
    @IBAction func btnMissedClick (_ sender:Any){
        self.btnMissed.setTitleColor(.black, for: .normal)
        self.btnMissed.backgroundColor = .clear
        
        self.btnMotion.setTitleColor(.white, for: .normal)
        self.btnMotion.backgroundColor = UIColor(named: "Color")
        
        self.btnUnknow.setTitleColor(.white, for: .normal)
        self.btnUnknow.backgroundColor = UIColor(named: "Color")
        self.intSelectedOption = 0
        self.getApi()
    }
    
    @IBAction func btnMotionClick (_ sender:Any){
        self.btnMotion.setTitleColor(.black, for: .normal)
        self.btnMotion.backgroundColor = .clear
        
        self.btnMissed.setTitleColor(.white, for: .normal)
        self.btnMissed.backgroundColor = UIColor(named: "Color")
        
        self.btnUnknow.setTitleColor(.white, for: .normal)
        self.btnUnknow.backgroundColor = UIColor(named: "Color")
        self.intSelectedOption = 1
        self.getApi()
    }
    
    @IBAction func btnUnknowClick (_ sender:Any){
        self.btnUnknow.setTitleColor(.black, for: .normal)
        self.btnUnknow.backgroundColor = .clear
        
        self.btnMissed.setTitleColor(.white, for: .normal)
        self.btnMissed.backgroundColor = UIColor(named: "Color")
        
        self.btnMotion.setTitleColor(.white, for: .normal)
        self.btnMotion.backgroundColor = UIColor(named: "Color")
        self.intSelectedOption = 2
        self.getApi()
    }
    
    
    func getApi(){
        SHOW_CUSTOM_LOADER()
        //self.arrStripeToken.removeAll()
        self.dictStatistic = StatisticListModel()
        let parameter : [String : Any] = ["":""]
        WebService.GetMethod(params: parameter as [String : AnyObject], apikey: Constants.get_notification_by_type, completion: { (json) in
            let dict = json as? NSDictionary
            let statusv = dict!["statusCode"] as? Int ?? 0
            if statusv == 200
            {
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    self.dictStatistic.initwith(dictionary: dict!["body"] as! Dictionary<String, Any>)
                    print(self.dictStatistic.notification.suspicious.count)
                    self.tblList.delegate = self
                    self.tblList.dataSource = self
                    self.tblList.reloadData()
                }
            }
            else{
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    Utils.popOnDialog(controller: self, title: self.navigationItem.title ?? "", message:"Something went wrong. Try again.")
                }
            }
        }, failure: {(error) in
            DispatchQueue.main.async {
                HIDE_CUSTOM_LOADER()
               // self.dispatchGroup.leave()
                Utils.popOnDialog(controller: self, title: self.navigationItem.title ?? "", message: "Something went wrong")
            }
        })
        }

}


extension StatisticVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.intSelectedOption == 0{
            return self.dictStatistic.notification.known.count
        }
        if self.intSelectedOption == 1{
            return self.dictStatistic.notification.suspicious.count
        }
        return self.dictStatistic.notification.unknown.count
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
        
//        cell?.lblTitle.text = self.dictNotification.Data.notification[indexPath.row]?.title ?? ""
//        cell?.lblDate.text = self.dictNotification.Data.notification[indexPath.row]?.time ?? ""
        
        if self.intSelectedOption == 0{
            cell?.lblTitle.text = self.dictStatistic.notification.known[indexPath.row].title ?? ""
            cell?.lblDate.text = self.dictStatistic.notification.known[indexPath.row].time ?? ""
        }
        else if self.intSelectedOption == 1{
            cell?.lblTitle.text = self.dictStatistic.notification.suspicious[indexPath.row].title ?? ""
            cell?.lblDate.text = self.dictStatistic.notification.suspicious[indexPath.row].time ?? ""
        }
        else{
            cell?.lblTitle.text = self.dictStatistic.notification.unknown[indexPath.row].title ?? ""
            cell?.lblDate.text = self.dictStatistic.notification.unknown[indexPath.row].time ?? ""
        }
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let VC = storyboard.instantiateViewController(withIdentifier: "ContactListVC") as? ContactListVC
        self.navigationController?.pushViewController(VC ?? UIViewController(), animated: true)
    }
}



class StatisticListModel : NSObject{
    var Response: String? = ""
    var Motion_Detected: Int? = 0
    var Unknowon_Detected: Int? = 0
    var notification = StatisticListDataModel()
    func initwith (dictionary : Dictionary<String,Any>){
        
        if let _obj = dictionary["Response"] as? CVarArg{
            self.Response = String(format: "%@", _obj)
            if self.Response == "<null>"{
                self.Response = ""
            }
        }
        if let _obj = dictionary["Motion_Detected"] as? Int{
            self.Motion_Detected = _obj
        }
        if let _obj = dictionary["Unknowon_Detected"] as? Int{
            self.Unknowon_Detected = _obj
        }
        if let _obj = dictionary["notification"] as? Dictionary<String,Any>{
            self.notification.initwith(dictionary: _obj)
        }
    }
}

class StatisticListDataModel : NSObject{
    var suspicious : [StatisticListnotificationModel] = []
    var animal : [StatisticListnotificationModel] = []
    
    var unknown : [StatisticListnotificationModel] = []
    var known : [StatisticListnotificationModel] = []
    
    func initwith (dictionary : Dictionary<String,Any>){
        if let _obj = dictionary["suspicious"] as? [Any]{
            for i in _obj{
                let mymodel = StatisticListnotificationModel()
                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
                self.suspicious.append(mymodel)
            }
        }
        if let _obj = dictionary["animal"] as? [Any]{
            for i in _obj{
                let mymodel = StatisticListnotificationModel()
                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
                self.suspicious.append(mymodel)
            }
        }
        if let _obj = dictionary["unknown"] as? [Any]{
            for i in _obj{
                let mymodel = StatisticListnotificationModel()
                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
                self.unknown.append(mymodel)
            }
        }
        if let _obj = dictionary["known"] as? [Any]{
            for i in _obj{
                let mymodel = StatisticListnotificationModel()
                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
                self.known.append(mymodel)
            }
        }
    }
}
class StatisticListnotificationModel : NSObject{
    var title: String? = ""
    var time: String? = ""
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
    }
}
