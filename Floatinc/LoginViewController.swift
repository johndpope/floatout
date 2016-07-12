//
//  ViewController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-19.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup default
        email.delegate = self
        password.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp(sender: UIButton) {
        print("Login is being pressed, fucking let the user get in.")
        if let passwordCount = password.text?.characters.count {
            if passwordCount < 6 {
                print("Alert: password should be greater or equal to 6 characters atleast")
                return
            }
        }
        FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!) { (user, error) in
            if let e = error {
                print("Unable to login, error is \(e)")
                let errorString = e.userInfo["error_name"] as! String
                
                
                switch(errorString) {
                case "ERROR_WRONG_PASSWORD":
                    print("bad password, try again or reset your password")
                    break
                case "ERROR_USER_NOT_FOUND":
                    print("no user with the corresponding emailId, create a new Account")
                    break
                case "ERROR_INVALID_EMAIL":
                    print("The email address is badly formatted, Invalid")
                    break
                default:
                    print("unable to login, please contact us")
                    break
                }
                
                
                
            } else {
                print("You are logged in, common float it now \(user?.email)")
                print("Popping the loginController leading to splashSCreen")
                let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
                let navRootController = appDelegate.window!.rootViewController as! UINavigationController
                navRootController.popViewControllerAnimated(true)
                //time to push the story
                print("Pushing the storyList on top of splashScreen")
                let storyViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("storyListVC")
                navRootController.pushViewController(storyViewController, animated: false)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

