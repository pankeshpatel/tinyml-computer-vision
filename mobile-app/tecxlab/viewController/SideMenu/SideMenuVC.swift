//
//  SideMenuVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 26/08/21.
//

import UIKit

class SideMenuVC: UIViewController {
    @IBOutlet weak var imgProfile : UIImageView!
    {
        didSet{
            self.imgProfile.layer.cornerRadius = 60
            self.imgProfile.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var tblList : UITableView!
    
    var arrSideMenu = NSMutableArray()
    var arrSideMenuImage = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblUserName.text = Constants.USERDEFAULTS.value(forKey: "username") as? String ?? ""
//        self.arrSideMenu = ["Home","Contacts","Videos Gallery","Statistics","Settings","Sign Out"]
//        self.arrSideMenuImage = ["home_icon","contact_icon","videoGallery_icon","Statistics_icon","settings_icon","SignOut_icon"]
        self.arrSideMenu = ["Home","Contacts","Videos Gallery","Statistics","Sign Out"]
        self.arrSideMenuImage = ["home_icon","contact_icon","videoGallery_icon","Statistics_icon","SignOut_icon"]
        
        self.tblList.delegate = self
        self.tblList.dataSource = self
        self.tblList.reloadData()
    }
}


extension SideMenuVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSideMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SideMenuCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SideMenuCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SideMenuCell", owner: self, options: nil)
            cell = nib?[0] as? SideMenuCell
        }
        cell?.layer.shouldRasterize = true
        cell?.layer.rasterizationScale = UIScreen.main.scale
        cell?.selectionStyle = .none
        cell?.lblTitle.text = self.arrSideMenu.object(at: indexPath.row) as? String
        cell?.imgMenu.image = UIImage(named: self.arrSideMenuImage.object(at: indexPath.row) as? String ?? "")
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        if indexPath.row == 0{
            let VC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
            let navigationController = mainViewController.rootViewController as! UINavigationController
            navigationController.pushViewController(VC ?? UIViewController(), animated: true)
            mainViewController.hideLeftView(animated: true)
        }
        if indexPath.row == 1{
            let VC = storyboard.instantiateViewController(withIdentifier: "ContactListVC") as? ContactListVC
            let navigationController = mainViewController.rootViewController as! UINavigationController
            navigationController.pushViewController(VC ?? UIViewController(), animated: true)
            mainViewController.hideLeftView(animated: true)
        }
        if indexPath.row == 2{
            let VC = storyboard.instantiateViewController(withIdentifier: "VideoGalleryVC") as? VideoGalleryVC
            let navigationController = mainViewController.rootViewController as! UINavigationController
            navigationController.pushViewController(VC ?? UIViewController(), animated: true)
            mainViewController.hideLeftView(animated: true)
        }
        if indexPath.row == 3{
            let VC = storyboard.instantiateViewController(withIdentifier: "StatisticVC") as? StatisticVC
            let navigationController = mainViewController.rootViewController as! UINavigationController
            navigationController.pushViewController(VC ?? UIViewController(), animated: true)
            mainViewController.hideLeftView(animated: true)
        }
        
        if indexPath.row == 4{
            self.AlertBox(Message: "Are you sure you want to sign out?")
        }
    }
    
    func AlertBox(Message : String){
        let alert = UIAlertController(title: "Sign Out", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { action in
            Constants.USERDEFAULTS.removeObject(forKey: "isLogin")
            Constants.USERDEFAULTS.removeObject(forKey: "access_token")
            Constants.USERDEFAULTS.removeObject(forKey: "username")
            Constants.appDelegate.setupLogin()
        }))
        self.present(alert, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
