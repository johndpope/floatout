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

class RegisterViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
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
            } else {
                print("You are a member of a prestigious app, congratualtions! \(user?.email)")
                //Return to the login Page
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func existingUser(sender: UIButton) {
        //Return to login page
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}

