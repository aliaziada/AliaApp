//
//  ViewController.swift
//  AliaShowCase
//
//  Created by Alia Ziada on 12/31/15.
//  Copyright © 2015 Ntime. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            print("\(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID))")
        }
    }
    
    @IBAction func fbBtnTapped(btn: UIButton!){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"]) { (fackbookResult: FBSDKLoginManagerLoginResult!,facebookError:  NSError!) -> Void in
            if facebookError != nil {
                print("Login failed . \(facebookError)")
            }else{
                if let token = FBSDKAccessToken.currentAccessToken() where token != "" {
                    let accessToken = token.tokenString
                    print("Successfully logged in with fack book \(accessToken)")
                    
                    DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error,authData in
                        if error != nil {
                            print("login faild. \(error)")
                        }else{
                            print("Logged Successfully ")
                            let user = ["provider": authData.provider!]
                            DataService.ds.createFirebaseUser(authData.uid, user: user)
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                    })
                }
            }
        }
        
    }
    @IBAction func emailBtnTapped (btn: UIButton!){
        if let email = emailField.text where email != "" , let pwd = passwordField.text where pwd != "" {
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error,authData in
                if error != nil {
                    print(error)
                    if error.code == STATUS_ACOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { err,result in
                            if err != nil {
                                self.showErrorAlert("Coundn't create account", msg: "problem createing acount")
                            }else{
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {err,authData in
                                    let user = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                })
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    }else if error.code == STATUS_WRONG_PASSWORD{
                        self.showErrorAlert("Coundn't log in account", msg: "Password is incorrect please check the password and try again")
                    }
                }else {
                    print(authData)
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
        }else{
            showErrorAlert("Email and password required", msg: "you must enter an email and password")
        }
    }
    func showErrorAlert(title: String,msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

