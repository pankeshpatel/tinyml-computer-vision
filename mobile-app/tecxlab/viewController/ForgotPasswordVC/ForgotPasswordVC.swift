//
//  ForgotPasswordVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 27/08/21.
//

import UIKit
import AWSCognitoIdentityProvider

class ForgotPasswordVC: UIViewController {
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var btnSubmit : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnbackclick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        
        
        if self.txtEmail.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Please enter a valid user name.")
            return
        }
        else{
            SHOW_CUSTOM_LOADER()
            self.user = self.pool?.getUser(self.txtEmail.text ?? "")
            self.user?.forgotPassword().continueWith{[weak self] (task: AWSTask) -> AnyObject? in
                guard let strongSelf = self else {return nil}
                DispatchQueue.main.async(execute: {
                    if let error = task.error as NSError? {
                        HIDE_CUSTOM_LOADER()
                        Utils.popDialog(controller: self!, title: "", message: error.userInfo["message"] as? String ?? "")
                       return
                    } else {
                       
                       // Utils().showMessage("Verification code has been sent to your email address.")
                        HIDE_CUSTOM_LOADER()
                        self?.AlertBox(title: "", Message: "Verification code has been sent to your email address.")
                        
                    }
                })
                return nil
            }
        }
        
        
    }
    
    
    func AlertBox(title:String,Message:String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
           // self.navigationController?.popViewController(animated: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let Reset = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC
            Reset?.username = self.txtEmail.text ?? ""
            self.navigationController?.pushViewController(Reset ?? UIViewController(), animated: true)
            
        }))
        self.present(alert, animated: true)
    }
   

}
