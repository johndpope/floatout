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
        FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!) { (user, error) in
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
    
//    func userLoggedIn(user: FIRUser) {
//        print("Pushing the main controller on the root controller and popping the login Controller off")
//        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
//        let navRootController = appDelegate.window!.rootViewController as! UINavigationController
//        navRootController.popViewControllerAnimated(true)
//    }
    
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

