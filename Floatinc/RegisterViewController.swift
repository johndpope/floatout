//
//  RegisterViewrController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-26.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let rootRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        userName.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func registerUser(sender: UIButton) {
        
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if let e = error {
                print("unable to register: Error is \(e)")
                let errorString = e.userInfo["error_name"] as! String
                
                switch(errorString) {
                case "ERROR_WEAK_PASSWORD":
                    print("weak password should be atleast 6 characters")
                    break
                case "ERROR_EMAIL_ALREADY_IN_USE":
                    print("The address is already in use by another account, Try resetting your password if you have an account with this email")
                    break
                case "ERROR_INVALID_EMAIL":
                    print("The email address is badly formatted, Invalid")
                    break
                default:
                    print("something else went wrong")
                    break
                }
            } else {
                print("You are a member of a prestigious app, congratualtions! \(user?.email)")
                self.rootRef.child("users").child(user!.uid).setValue(["username": self.userName.text!])
                
                //Return to the login Page
                self.dismissViewControllerAnimated(true, completion: nil)
           
                //logging in after registeration
                FIRAuth.auth()?.signInWithEmail(self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                    if let e = error {
                        print("Unable to login, error is \(e)")

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
        })
    }
    
    @IBAction func existingUser(sender: UIButton) {
        //Return to login page
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}

