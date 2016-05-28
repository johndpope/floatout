//
//  mainViewController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-26.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit

class SplashViewController : UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("In the splash screen")
//        self.performSegueWithIdentifier("loginView", sender: self)
    }
}
