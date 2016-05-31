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
