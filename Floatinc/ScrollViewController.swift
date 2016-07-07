////
////  ScrollViewController.swift
////  Floatinc
////
////  Created by Vedant Khattar on 2016-05-28.
////  Copyright © 2016 Vedant Khattar. All rights reserved.
////
//
//import UIKit
//
//
//class ScrollViewController: UIViewController {
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    
//        let mainViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("mainVC")
//        let storyListTableViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("storyListVC")
//        
//        self.addChildViewController(mainViewController)
//        self.scrollView.addSubview(mainViewController.view)
//        mainViewController.didMoveToParentViewController(self)
//        
//        var mainVCFrame : CGRect = mainViewController.view.frame
//        mainVCFrame.origin.x = self.view.frame.width
//        mainViewController.view.frame = mainVCFrame
//        
//        print("FUCKING SHIT EH")
//        self.scrollView.contentSize = CGSizeMake(self.view.frame.width*2, self.view.frame.height)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}
