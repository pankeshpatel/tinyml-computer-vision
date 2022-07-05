//
//  AppDelegate.swift
//  tecxlab
//
//  Created by bhavin joshi on 26/08/21.
//

import UIKit
import LGSideMenuController
import AWSCognito
import AWSCore
import AWSCognitoIdentityProvider
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigationController: UINavigationController?
    var signInViewController: LoginVC?
    
    var window: UIWindow?
    var storyboard: UIStoryboard?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        AWSDDLog.sharedInstance.logLevel = .verbose
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        // setup service configuration
        
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
        AWSServiceManager.default()?.defaultServiceConfiguration = serviceConfiguration
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,
                                                                        clientSecret: CognitoIdentityUserPoolAppClientSecret,
                                                                        poolId: CognitoIdentityUserPoolId)
        
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        // fetch the user pool client we initialized in above step
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        self.pool?.delegate = self
        
        if self.user == nil {
            self.user = self.pool?.currentUser()
        }
        else{
            self.sidemenusetup()
        }
        refresh()
        
        // Override point for customization after application launch.
        return true
    }
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
            return nil
        })
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func setupHomePage(){
//     
//            let storyboard = UIStoryboard(name: "Home", bundle: nil)
//            let rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
//            
//            let navigationController = UINavigationController(rootViewController: rootViewController!)
//            navigationController.isNavigationBarHidden = true
//            window!.rootViewController = navigationController
//            window!.makeKeyAndVisible()
//        
//    }
    
    
  
    
    func sidemenusetup()
    {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC
        let navigationController = UINavigationController(rootViewController: rootViewController!)
        navigationController.isNavigationBarHidden = false // or not, your choice.
        let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                      leftViewController: leftViewController,
                                                      rightViewController: nil)
        if UIDevice.current.userInterfaceIdiom == .pad{
            sideMenuController.leftViewWidth = 450
        }
        else{
            sideMenuController.leftViewWidth = 300
        }
        
        
        if #available(iOS 13.0, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor(named: "Color")
                    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                    navigationController.navigationBar.standardAppearance = appearance;
                    navigationController.navigationBar.scrollEdgeAppearance = appearance
                } else {
                    // Fallback on earlier versions
                }
        
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 15)!,.foregroundColor: UIColor.white]
       
       // navigationController.navigationBar.barStyle = .blackOpaque
        navigationController.navigationBar.barTintColor = UIColor(named: "Color")
        navigationController.navigationBar.isTranslucent = false
//
       // navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        sideMenuController.leftViewPresentationStyle = .slideAbove
        UIApplication.shared.windows.first?.rootViewController = sideMenuController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }


    func setupLogin()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let navigationController = UINavigationController(rootViewController: rootViewController!)
        navigationController.isNavigationBarHidden = true // or not, your choice.
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
}



extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        if (self.navigationController == nil) {
            self.navigationController = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageNav") as? UINavigationController
        }
        
        if (self.signInViewController == nil) {
            self.signInViewController = self.navigationController?.viewControllers[0] as? LoginVC
        }

        //self.window?.rootViewController = self.navigationController!
        UIApplication.shared.windows.first?.rootViewController = self.navigationController!
        
        return self.signInViewController!
    }
    
}
