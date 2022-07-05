//
//  ResetPasswordVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 27/08/21.
//

import UIKit
import AWSCognitoIdentityProvider

class ResetPasswordVC: UIViewController {
    var username = String()
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    @IBOutlet weak var txtconfirmpassword: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtcode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if self.user == nil {
            self.user = self.pool?.currentUser()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnbackclick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnsendcodeclick(_ sender: Any) {
       
        
        var code = self.txtcode.text ?? ""
        code = code.trimmingCharacters(in: .whitespacesAndNewlines)
        var password = self.txtpassword.text ?? ""
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        var confirmpassword = self.txtconfirmpassword.text ?? ""
        confirmpassword = confirmpassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if code == ""{
            
        }
        else if password == ""{
            Utils.popDialog(controller: self, title: "", message: "Please enter password.")
            return
        }
        else if !self.isValidated(password){
            Utils.popDialog(controller: self, title: "", message: "Password must be minimum 8 characters, at least 1 Uppercase Alphabet, 1 Lowercase Alphabet,1 Number and 1 Special Character")
            return
        }
        else if confirmpassword == ""{
            Utils.popDialog(controller: self, title: "", message: "Please enter confirm password.")
            return
        }
        else if password != confirmpassword{
            Utils.popDialog(controller: self, title: "", message: "Confirm password and password must be same.")
            return
        }
        
        else
        {
        SHOW_CUSTOM_LOADER()
        self.user = self.pool?.getUser(self.username)
        self.user?.confirmForgotPassword(code, password: password).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    HIDE_CUSTOM_LOADER()
                    Utils.popDialog(controller: self!, title: "", message: error.userInfo["message"] as? String ?? "")
                    return
                } else {
                    HIDE_CUSTOM_LOADER()
                    self?.AlertBox(title: "", Message: "Password Reset Successfully.")
                }
            })
            return nil
        }
        }
    }
    
    
    func AlertBox(title:String,Message:String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
            
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
