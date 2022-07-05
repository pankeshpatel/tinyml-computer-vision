//
//  ContactListVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 04/09/21.
//

import UIKit
import SDWebImage

class ContactListVC: UIViewController {
    @IBOutlet weak var btnFamily : UIButton!
    @IBOutlet weak var btnFriend : UIButton!
    @IBOutlet weak var btnVisitor : UIButton!
    @IBOutlet weak var tblList : UITableView!
    
    private var contactViewModel : ContactListVM!
    private var deleteFaceModel : ContactListVM!
    
    var strGroup = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationbarButtons()
        self.navigationItem.title = "Contacts"
        self.btnFamilyClick(self)
    }
    
    func callToViewModelForUIUpdate(group_type : String){
        SHOW_CUSTOM_LOADER()
        self.contactViewModel =  ContactListVM(groupName: group_type)
        self.contactViewModel.bindContactListViewModelController = {
            //self.updateDataSource()
            if self.contactViewModel.contactData.statusCode == 200{
                DispatchQueue.main.async {
                    self.tblList.delegate = self
                    self.tblList.dataSource = self
                    self.tblList.reloadData()
                    HIDE_CUSTOM_LOADER()
                }
            }
            else{
                DispatchQueue.main.async {
                    self.tblList.delegate = self
                    self.tblList.dataSource = self
                    self.tblList.reloadData()
                    HIDE_CUSTOM_LOADER()
                }
            }
        }
    }
    
    func navigationbarButtons(){
        let sidemenubtn = UIBarButtonItem(image: UIImage(named: "side_menu"), style: .plain, target: self, action: #selector(SidemnuClick))
        navigationItem.leftBarButtonItems = [sidemenubtn]
        
        let addbtn = UIBarButtonItem(image: UIImage(named: "Add_Contact"), style: .plain, target: self, action: #selector(AddContactClick))
        navigationItem.rightBarButtonItems = [addbtn]
    }
    
    @objc func SidemnuClick(){
        self.sideMenuController?.showLeftView()
    }
    
    @objc func AddContactClick(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        self.navigationController?.pushViewController(VC ?? UIViewController(), animated: true)
    }
    
    @IBAction func btnFamilyClick (_ sender:Any){
        self.btnFamily.setTitleColor(.black, for: .normal)
        self.btnFamily.backgroundColor = .clear
        
        self.btnFriend.setTitleColor(.white, for: .normal)
        self.btnFriend.backgroundColor = UIColor(named: "Color")
        
        self.btnVisitor.setTitleColor(.white, for: .normal)
        self.btnVisitor.backgroundColor = UIColor(named: "Color")
        self.strGroup = "Family"
        
        self.callToViewModelForUIUpdate(group_type: "Family")
        //self.getContact(group: self.strGroup)
    }
    
    @IBAction func btnFriendClick (_ sender:Any){
        self.btnFriend.setTitleColor(.black, for: .normal)
        self.btnFriend.backgroundColor = .clear
        
        self.btnFamily.setTitleColor(.white, for: .normal)
        self.btnFamily.backgroundColor = UIColor(named: "Color")
        
        self.btnVisitor.setTitleColor(.white, for: .normal)
        self.btnVisitor.backgroundColor = UIColor(named: "Color")
        self.strGroup = "Friend"
        self.callToViewModelForUIUpdate(group_type: "Friend")
        //self.getContact(group: self.strGroup)
    }
    
    @IBAction func btnVisitorClick (_ sender:Any){
        self.btnVisitor.setTitleColor(.black, for: .normal)
        self.btnVisitor.backgroundColor = .clear
        
        self.btnFriend.setTitleColor(.white, for: .normal)
        self.btnFriend.backgroundColor = UIColor(named: "Color")
        
        self.btnFamily.setTitleColor(.white, for: .normal)
        self.btnFamily.backgroundColor = UIColor(named: "Color")
        self.strGroup = "Visitor"
        self.callToViewModelForUIUpdate(group_type: "Visitor")
        //self.getContact(group: self.strGroup)
    }
}


extension ContactListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactViewModel.contactData.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ContactListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ContactListCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("ContactListCell", owner: self, options: nil)
            cell = nib?[0] as? ContactListCell
        }
        cell?.layer.shouldRasterize = true
        cell?.layer.rasterizationScale = UIScreen.main.scale
        cell?.selectionStyle = .none
        
        cell?.lblName.text = self.contactViewModel.contactData.data?[indexPath.row].fullname
        cell?.lblType.text = self.contactViewModel.contactData.data?[indexPath.row].group
        cell?.imgProfile.sd_setImage(with: URL(string:self.contactViewModel.contactData.data?[indexPath.row].img ?? ""), placeholderImage: UIImage(named: "user_placeholder"))
        
        cell?.btnDelete.tag = indexPath.row
        cell?.btnDelete.addTarget(self, action: #selector(btnDeleteClick), for: .touchUpInside)
        
        return cell!
    }
    
    
    @objc func btnDeleteClick(sender:UIButton){
        
        if Reachability.isConnectedToNetwork(){
            self.AlertBox(title: "Delete Contact", Message: "Are you sure you want to delete \(self.contactViewModel.contactData.data?[sender.tag].fullname ?? "")?", selected: sender.tag)
        }else{
            Utils.popDialog(controller: self, title: "Delete Contact", message: Constants.NetworkUnavailable)
        }
        
    }
    
    
    func AlertBox(title:String,Message:String,selected:Int){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { action in
            self.deleteContact(selected: selected)
        }))
        
        self.present(alert, animated: true)
    }
    
    func deleteContact(selected:Int){
        //SHOW_CUSTOM_LOADER()
        
        self.deleteFaceModel = ContactListVM(fullname: self.contactViewModel.contactData.data?[selected].fullname ?? "", isDelete: true)
        self.deleteFaceModel.bindContactDeleteViewModelController = {
            self.callToViewModelForUIUpdate(group_type: self.strGroup)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ContactDetailVC") as? ContactDetailVC
        VC?.fullName = self.contactViewModel.contactData.data?[indexPath.row].fullname ?? ""
        self.navigationController?.pushViewController(VC ?? UIViewController(), animated: true)
    }
}

//class ContactListModel : NSObject{
//    var Response: String? = ""
//    var Data : [ContatcListDataModel] = []
//    func initwith (dictionary : Dictionary<String,Any>){
//
//        if let _obj = dictionary["Response"] as? CVarArg{
//            self.Response = String(format: "%@", _obj)
//            if self.Response == "<null>"{
//                self.Response = ""
//            }
//        }
//        if let _obj = dictionary["Data"] as? [Any]{
//            for i in _obj{
//                let mymodel = ContatcListDataModel()
//                mymodel.initwith(dictionary: i as! Dictionary<String, Any>)
//                self.Data.append(mymodel)
//            }
//        }
//    }
//}
//class ContatcListDataModel : NSObject{
//    var emailId: String? = ""
//    var group: String? = ""
//    var fullname: String? = ""
//    var phone: String? = ""
//    var img: String? = ""
//    func initwith (dictionary : Dictionary<String,Any>){
//
//        if let _obj = dictionary["emailId"] as? String{
//            self.emailId = String(format: "%@", _obj)
//            if self.emailId == "<null>"{
//                self.emailId = ""
//            }
//        }
//        if let _obj = dictionary["group"] as? String{
//            self.group = String(format: "%@", _obj)
//            if self.group == "<null>"{
//                self.group = ""
//            }
//        }
//        if let _obj = dictionary["fullname"] as? String{
//            self.fullname = String(format: "%@", _obj)
//            if self.fullname == "<null>"{
//                self.fullname = ""
//            }
//        }
//        if let _obj = dictionary["phone"] as? String{
//            self.phone = String(format: "%@", _obj)
//            if self.phone == "<null>"{
//                self.phone = ""
//            }
//        }
//        if let _obj = dictionary["img"] as? String{
//            self.img = String(format: "%@", _obj)
//            if self.img == "<null>"{
//                self.img = ""
//            }
//        }
//    }
//}

