//
//  SignUpVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 27/08/21.
//

import UIKit
import AWSCognitoIdentityProvider

class SignUpVC: UIViewController {

    var pool: AWSCognitoIdentityUserPool?
    
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfPassword : UITextField!
    @IBOutlet weak var btnSignUp : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backclick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterclick(_ sender: Any) {
        
        if self.txtUserName.text ?? "" == "" {
            Utils.popDialog(controller: self, title: "", message: "Enter User Name")
            return
        }
        else if self.txtEmail.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Enter Emial Address")
            return
        }
        else if !Utils().isValidEmailAddress(emailAddressString: self.txtEmail.text ?? ""){
            Utils.popDialog(controller: self, title: "", message: "Please enter valid email address.")
            return
        }
        else if self.txtPassword.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Enter Password")
            return
        }
        else if !self.isValidated(self.txtPassword.text ?? ""){
            Utils.popDialog(controller: self, title: "", message: "Password must be minimum 8 characters, at least 1 Uppercase Alphabet, 1 Lowercase Alphabet,1 Number and 1 Special Character")
            return
        }
        else if self.txtConfPassword.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Enter Confirm Password")
            return
        }
        
        else if self.txtPassword.text ?? "" != self.txtConfPassword.text ?? ""{
            Utils.popDialog(controller: self, title: "", message: "Password and Confirm Password Must be same")
            return
        }
        
        else{
            var attributes = [AWSCognitoIdentityUserAttributeType]()
        
                let name = AWSCognitoIdentityUserAttributeType()
                name?.name = "name"
                name?.value = self.txtUserName.text ?? ""
                attributes.append(name!)
          
                    let email = AWSCognitoIdentityUserAttributeType()
                    email?.name = "email"
            email?.value = self.txtEmail.text ?? ""
                    attributes.append(email!)
            
            
            var password = self.txtPassword.text!
            password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            var confirmpassword = self.txtConfPassword.text!
            confirmpassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
            
            SHOW_CUSTOM_LOADER()

            //sign up the user
            self.pool?.signUp(self.txtUserName.text ?? "", password: self.txtPassword.text ?? "", userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
                guard let strongSelf = self else { return nil }
                DispatchQueue.main.async(execute: {
                      
                    if let error = task.error as NSError? {
                        HIDE_CUSTOM_LOADER()
                        Utils.popDialog(controller: self!, title: "", message: (error.userInfo["message"] as? String ?? ""))
                        return
                    } else if let result = task.result  {
                        HIDE_CUSTOM_LOADER()
                        if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                            
                            self?.AlertBox(title: "", Message: "We have sent you an email to complete registration. Click on the link an activate your account")
                        } else {
                            let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                })
                return nil
            }
        }
    
        
        
    }
    
    func AlertBox(title:String,Message:String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
 
    
    func isValidated(_ password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false
        
        if password.count  >= 8 {
            for char in password.unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if specialCharacter || (digit && lowerCaseLetter && upperCaseLetter) {
                //do what u want
                return true
            }
            else {
                return false
            }
        }
        return false
    }

}
