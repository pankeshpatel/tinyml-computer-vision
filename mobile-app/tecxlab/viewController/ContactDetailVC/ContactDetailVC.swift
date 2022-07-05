//
//  ContactDetailVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 04/09/21.
//

import UIKit

class ContactDetailVC: UIViewController {
    
    private var contactDetailata : ContactDetailVM!
    
    var fullName = String()
    var dictContactDetail = ContactDetailModel()
    
    @IBOutlet weak var imgProfile : UIImageView!{
        didSet{
            self.imgProfile.layer.cornerRadius = 50
            self.imgProfile.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblPhone : UILabel!
    @IBOutlet weak var lblGroup : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationbarButtons()
        //self.getContactDetail(fullname: fullName)
        self.callToViewModelForUIUpdate(fullname: fullName)
        // Do any additional setup after loading the view.
    }
    
    func navigationbarButtons(){
        let sidemenubtn = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(SidemnuClick))
        navigationItem.leftBarButtonItems = [sidemenubtn]
        
        let editbtn = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(EditProfileClick))
        navigationItem.rightBarButtonItems = [editbtn]
    }
    
    @objc func SidemnuClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func EditProfileClick(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        VC?.isEditProfile = true
        VC?.contactDetailata = self.contactDetailata
        //VC?.dictContactDetail = self.dictContactDetail
        self.navigationController?.pushViewController(VC ?? UIViewController(), animated: true)
    }
    
    
    func callToViewModelForUIUpdate(fullname : String){
        SHOW_CUSTOM_LOADER()
        self.contactDetailata =  ContactDetailVM(groupName: fullname)
        self.contactDetailata.bindContactDetailViewModelController = {
            //self.updateDataSource()
            if self.contactDetailata.contactDetailData.statusCode == 200{
                DispatchQueue.main.async {
                    self.lblName.text = "Name : \(self.contactDetailata.contactDetailData.body?.fullname ?? "")"
                    self.lblEmail.text = "Email Address : \(self.contactDetailata.contactDetailData.body?.emailID ?? "")"
                    self.lblPhone.text = "Phone Number : \(self.contactDetailata.contactDetailData.body?.phone ?? "")"
                    self.lblGroup.text = "Group : \(self.contactDetailata.contactDetailData.body?.group ?? "")"
                    self.imgProfile.sd_setImage(with: URL(string:self.contactDetailata.contactDetailData.body?.img ?? ""), placeholderImage: UIImage(named: "user_placeholder"))
                    
                    HIDE_CUSTOM_LOADER()
                }
            }
            
        }
    }
}

class ContactDetailModel : NSObject{
    var emailId: String? = ""
    var fullname: String? = ""
    var group: String? = ""
    var img: String? = ""
    var phone: String? = ""
    func initwith (dictionary : Dictionary<String,Any>){
        
        if let _obj = dictionary["emailId"] as? CVarArg{
            self.emailId = String(format: "%@", _obj)
            if self.emailId == "<null>"{
                self.emailId = ""
            }
        }
        if let _obj = dictionary["fullname"] as? CVarArg{
            self.fullname = String(format: "%@", _obj)
            if self.fullname == "<null>"{
                self.fullname = ""
            }
        }
        if let _obj = dictionary["group"] as? CVarArg{
            self.group = String(format: "%@", _obj)
            if self.group == "<null>"{
                self.group = ""
            }
        }
        if let _obj = dictionary["img"] as? CVarArg{
            self.img = String(format: "%@", _obj)
            if self.img == "<null>"{
                self.img = ""
            }
        }
        if let _obj = dictionary["phone"] as? CVarArg{
            self.phone = String(format: "%@", _obj)
            if self.phone == "<null>"{
                self.phone = ""
            }
        }
    }
}
