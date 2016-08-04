//
//  AppDelegate.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-19.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    private var tokenId: String?
  
    var listener : FIRAuthStateDidChangeListenerHandle? {
        didSet {
            FIRAuth.auth()?.removeAuthStateDidChangeListener(listener!)
        }
    }
    
    override init() {
        super.init()
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // [START register_for_notifications]
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        // Add observer for InstanceID token refresh callback.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification),name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        
        // Override point for customization after application launch.
        let navController = self.window?.rootViewController as! UINavigationController

       listener = FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("lord has floated in with his identity email \(user.email)")

                user.getTokenForcingRefresh(false, completion: { (tokenId, error) in
                    if let error = error {
                        print("Could not get the token, let the login begin \(error)")
                        self.navToLogin(navController)
                    }
                    else {
                        print("saving the token, will refresh if expired")
                        self.tokenId = tokenId
                        //Taking them to the main screen
                        let storyViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("storyListVC")
                        navController.pushViewController(storyViewController, animated: false)
                    }
                })
            }
            else {
                print("No baby no user is logged in let me take them to the log in screen")
                self.navToLogin(navController)
            }
       })
       
        
        //Adding the API key for google maps
        GMSServices.provideAPIKey("AIzaSyDDpJNdJcPzjeAGl4vqAGgkiAd8g_a_1UQ")
        
        return true
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let r =  FIRInstanceID.instanceID().token() {
            let refreshedToken = r
            print("InstanceID token: \(refreshedToken)")
            
            // Connect to FCM since connection may have failed when attempted before having a token.
            connectToFcm()
        }

    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    // NOTE: Need to use this when swizzling is disabled
    internal func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        //change the production TODO
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Messsage ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    func navToLogin(navController: UINavigationController){
        print("Pushing login controller on the navController")
        let loginViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("loginVC")
        navController.pushViewController(loginViewController, animated: false)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
            }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

