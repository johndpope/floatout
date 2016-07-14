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
                self.showAlert("Invalid Password", message: "Please Fill the Password again, hint: minimum 6 characters", textField: self.password)
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
                    self.showAlert("Invalid Password", message: "Please Fill the Password again", textField: self.password)
                    break
                case "ERROR_USER_NOT_FOUND":
                    print("no user with the corresponding emailId, create a new Account")
                    self.showAlert("Invalid EmailId", message: "No user found with this email address, try again!", textField: self.email)
                    break
                case "ERROR_INVALID_EMAIL":
                    print("The email address is badly formatted, Invalid")
                    self.showAlert("Bad format for Email", message: "The email address is badly formatted", textField: self.email)
                    break
                default:
                    print("unable to login, please contact us")
                    self.showAlert("Cannot Login", message: errorString, textField: self.password)
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
    
    @IBAction func forgotPassword(sender: UIButton) {
        //
        var alert = UIAlertController(title: "Reset your Password ", message: "Please enter your email address and we will send you a link so you can reset your password", preferredStyle: UIAlertControllerStyle.Alert);
        
        //configured input textField
        var field:UITextField?;// operator ? because it's been initialized later
        
        alert.addTextFieldWithConfigurationHandler({(input:UITextField)in
            input.placeholder="Enter your email address";
            input.clearButtonMode=UITextFieldViewMode.WhileEditing;
            input.keyboardType = .EmailAddress
            field=input;//assign to outside variable(for later reference)
        });
    
        func yesHandler(actionTarget: UIAlertAction){
            print("YES -> Sending the reset email");
            //print text from 'field' which refer to relevant input now
            print(field!.text!);//operator ! because it's Optional here
            
            let email = field!.text!
            
            FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
                if let error = error {
                    // An error happened.
                    print("error is while resetting the email: \(error)")
                } else {
                    // Password reset email sent.
                    print("email has been sent")
                }
            }
        }
        //event handler with predefined function
        alert.addAction(UIAlertAction(title: "Send Reset Email", style: UIAlertActionStyle.Default, handler: yesHandler));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil);
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
    
    func showAlert(title: String, message: String, textField: UITextField? = nil) {
        
        let alertView = UIAlertController( title: title,
                                           message: message,
                                           preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // do something when user press OK button, like deleting text in both fields or do nothing
            if let textFieldToClear = textField{
                textFieldToClear.text =  ""
            }
        }
        
        alertView.addAction(OKAction)
        
        self.presentViewController(alertView, animated: true, completion: nil)
        return
    }
}

