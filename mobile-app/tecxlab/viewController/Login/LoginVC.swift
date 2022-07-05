//
//  LoginVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 26/08/21.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class LoginVC: UIViewController {
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    var didSignInObserver: AnyObject!
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    var usernameText: String?
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnSubmit : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if self.user == nil {
            self.user = self.pool?.currentUser()
        }
        
        if Constants.USERDEFAULTS.value(forKey: "isLogin") as? String ?? "" == "1"{
            Constants.appDelegate.sidemenusetup()
        }
        
        self.txtEmail.text = "arya"
        self.txtPassword.text = "secret"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.user?.signOutAndClearLastKnownUser()
        self.user?.signOutAndClearLastKnownUser()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.refresh()
    }
    
    func tokenCall(){
        SHOW_CUSTOM_LOADER()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dictParam = NSMutableDictionary()
        dictParam.setValue("arya", forKey: "username")
        dictParam.setValue("secret", forKey: "password")
        
        
        WebService.postToken(params: dictParam as! [String : AnyObject], apikey: Constants.Token, completion: { (json) in
            let dict = json as? NSDictionary
            let access_token = dict!["access_token"] as? String ?? ""
            
            let statusv = dict!["status_code"] as? Int ?? 0
            if statusv == 200
            {
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    Constants.USERDEFAULTS.setValue(access_token, forKey: "access_token")
                    Constants.USERDEFAULTS.setValue(self.txtEmail.text ?? "", forKey: "username")
                    Constants.USERDEFAULTS.setValue("1", forKey: "isLogin")
                    appDelegate.sidemenusetup()
//                    KeychainInterface.saveLoginData(password: "secret", service: "com.app.techxlab", account: self.txtEmail.text ?? "", authToken: access_token) { success, Message in
//                        if success{
//                            appDelegate.sidemenusetup()
//                        }
//                        else{
//                            Utils.popOnDialog(controller: self, title: self.navigationItem.title ?? "", message: "Keychain error")
//                        }
//                    }
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
    
    
    
    @IBAction func btnSubmitClick (_ sender:Any){
        
        
        Constants.USERDEFAULTS.setValue(self.txtEmail.text ?? "", forKey: "username")
        
        self.tokenCall()
        
        //        var username = self.txtEmail.text ?? ""
        //        var password = self.txtPassword.text ?? ""
        //        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        //        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        //
        //        if (username != "" && password != "") {
        //
        //            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password)
        //            self.passwordAuthenticationCompletion?.set(result: authDetails)
        //        } else {
        //            let alertController = UIAlertController(title: "Login",
        //                                                    message: "Please enter a valid user name and password",
        //                                                    preferredStyle: .alert)
        //            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
        //            alertController.addAction(retryAction)
        //        }
    }
    
    @IBAction func btnSignUpClick (_ sender:Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SignPage = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(SignPage ?? UIViewController(), animated: true)
    }
    
    @IBAction func btnForgotClick (_ sender:Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(VC ?? UIViewController(), animated: true)
    }
    
}


extension LoginVC: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
            if (self.usernameText == nil) {
                self.usernameText = authenticationInput.lastKnownUsername
            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                
                let alertController = UIAlertController(title: "Login",
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                Constants.USERDEFAULTS.setValue(self.txtEmail.text ?? "", forKey: "username")
                
                KeychainInterface.saveLoginData(password: "Swami@1992", service: "com.app.techxlab", account: self.txtEmail.text ?? "", authToken: "123") { success, Message in
                    appDelegate.sidemenusetup()
                }
                
            }
        }
    }
}
