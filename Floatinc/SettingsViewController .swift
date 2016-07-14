//
//  MainViewController .swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-26.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController : UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //logs out and takes back to the login Screen
    @IBAction func userLogout(sender: UIButton) {
        print("Yikes the user wants to logout :-( ")
        try! FIRAuth.auth()!.signOut()
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        let navController = appDelegate.window!.rootViewController as! UINavigationController
        navController.popToRootViewControllerAnimated(false)
        let loginViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("loginVC")
        navController.pushViewController(loginViewController, animated: false)
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
        let user = FIRAuth.auth()?.currentUser
        
        var alert=UIAlertController(title: "Update your Password", message: "Enter your new password", preferredStyle: UIAlertControllerStyle.Alert);
        
        //configured input textField
        var oldPassword:UITextField?;
        var newPassword:UITextField?;
    
        
        alert.addTextFieldWithConfigurationHandler({(input:UITextField)in
            input.placeholder="Enter your current Password";
            input.clearButtonMode=UITextFieldViewMode.WhileEditing;
            input.secureTextEntry = true
            oldPassword=input;//assign to outside variable(for later reference)
        });
        
        
        alert.addTextFieldWithConfigurationHandler({(input:UITextField)in
            input.placeholder="Enter your new Password";
            input.clearButtonMode=UITextFieldViewMode.WhileEditing;
            input.secureTextEntry = true
            newPassword=input;//assign to outside variable(for later reference)
        });
        
        func updatePasswordHandler(actionTarget: UIAlertAction){
            if  let user = FIRAuth.auth()?.currentUser {
                let credential = FIREmailPasswordAuthProvider.credentialWithEmail(user.email!, password: oldPassword!.text!)
                user.reauthenticateWithCredential(credential) { error in
                    if let error = error {
                        print("user could not be reauthenticated \(error)")
                        self.showAlert("Unable to reauthenticate", message: error.userInfo.description)
                        return
                    } else {
                        print("user reauthincated successfully")
                        user.updatePassword(newPassword!.text!) { error in
                            if let error = error {
                                // An error happened.
                                print("Sorry could not change the password")
                                self.showAlert("Password could not be updated", message: error.userInfo.description)
                            }
                            else {
                                // Password updated.
                                print("password successfully changed")
                                self.showAlert("Password successfully updated", message: "Now you can login with your new password")
                            }
                        }
                    }
                }
        
            }
        }
        //event handler with predefined function
        alert.addAction(UIAlertAction(title: "Update Password", style: UIAlertActionStyle.Default, handler: updatePasswordHandler));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil);
    }
    
    @IBAction func changeUsername(sender: UIButton) {
    
        let user = FIRAuth.auth()?.currentUser
        
        var alert=UIAlertController(title: "Update your Username", message: "Enter your new username", preferredStyle: UIAlertControllerStyle.Alert);
        
        //configured input textField
        var currentUserName:UITextField?;
        var newUserName:UITextField?;
        
        alert.addTextFieldWithConfigurationHandler({(input:UITextField) in
            input.placeholder="Enter your current username";
            input.clearButtonMode=UITextFieldViewMode.WhileEditing;
            currentUserName=input;//assign to outside variable(for later reference)
        });
        
        alert.addTextFieldWithConfigurationHandler({(input:UITextField) in
            input.placeholder="Enter your new username";
            input.clearButtonMode=UITextFieldViewMode.WhileEditing;
            newUserName=input;//assign to outside variable(for later reference)
        });
        
        func updateUserNameHandler(actionTarget: UIAlertAction){
            
            if newUserName?.text?.characters.count <= 0 {
                self.showAlert("New username is empty!", message: "username should be at least more than 0 characters")
                return
            }
            
            if  let user = FIRAuth.auth()?.currentUser {
                let uid = user.uid
                let rootRef = FIRDatabase.database().reference()
                var userName : String?
                
                rootRef.child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    // Get user value
                    userName = snapshot.value!["username"] as? String
                    if currentUserName?.text == userName {
                        //writing to the database, updating the username
                        rootRef.child("users").child(user.uid).setValue(["username": newUserName!.text!])
                        self.showAlert("Username updated", message: "Your new username is \(newUserName!.text!)")
                    }
                    else {
                        self.showAlert("Invalid username", message: "username did not match the one in our records")
                        return
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
        //event handler with predefined function
        alert.addAction(UIAlertAction(title: "Update Username", style: UIAlertActionStyle.Default, handler: updateUserNameHandler));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil);
    }
    
    
    @IBAction func backToStoryViewController(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("Hello Mr. User you are in the main hashtag screen")
    }
}
