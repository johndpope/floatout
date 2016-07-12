//
//  firebase.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-07.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class StoreImage {
    
    //google storage refs
    var gStorageRef : FIRStorageReference?
    var gStoryFeedRef : FIRStorageReference?
    var gStoryFeedStore: StoryFeedStore!
    let gStorage  = FIRStorage.storage()
    
    //firebase refs
    let rootRef = FIRDatabase.database().reference()
    let storyFeedRef : FIRDatabaseReference?
    let storyTagStatsRef: FIRDatabaseReference?
    
    init() {
        self.gStorageRef = gStorage.referenceForURL("gs://floatout-2417e.appspot.com")
        self.gStoryFeedRef = gStorageRef!.child("storyFeed")
        self.storyFeedRef = rootRef.child("storyFeed")
        self.storyTagStatsRef = rootRef.child("storyTagStats")
    }

    func saveImage(data: NSData, mediaType: String, storyTag: String, description: String, location: AnyObject?) {
        
        let nameFirstPart = FIRAuth.auth()?.currentUser?.email
        let storyMedia = self.storyFeedRef!.child("\(storyTag)")
        let storyMediaKey = storyMedia.childByAutoId().key
        let fullName = "\(nameFirstPart!)\(storyMediaKey)"

        let gUrlName = "\(storyTag)/\(fullName).jpg"
        let saveRef = gStoryFeedRef!.child(gUrlName)
        
        //upload the file to gstore
//        let metadata = FIRStorageMetadata()
//        metadata.contentType = "image/jpeg"
        
        _ = saveRef.putData(data, metadata: nil){ metadata, error in
            if (error != nil) {
                print("error")
            }
            else {
                self.displayToastWithMessage("Added to the story :)")
                print("PhotoHasBeenUploaded. Done")

                let uid = FIRAuth.auth()?.currentUser?.uid
                //save to Firebase storyFeed
                let gStorageUrl = metadata?.name
                var feedAttributes = [String: AnyObject]()
                feedAttributes = ["url": gStorageUrl!, "userid": uid!, "description": description, "likes": ["likeCount": 0]]
                
                if let location = location {
                    let latitude = location.coordinate.latitude 
                    let longitude = location.coordinate.longitude
                    let metadataDict = ["location": ["latitude": latitude, "longitude": longitude]]
                    feedAttributes["metadata"] = metadataDict
                    storyMedia.child(storyMediaKey).setValue(feedAttributes)
                }
                else {
                    storyMedia.child(storyMediaKey).setValue(feedAttributes)
                }
    
                //save to Firebase storyTagStats contribution:
               
                let userFeed = self.storyTagStatsRef!.child("\(storyTag)/users/\(uid!)/contribution")
                userFeed.child(storyMediaKey).setValue(gStorageUrl)
            }
        }
    }
    
    
    func displayToastWithMessage(toastMessage: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
            let keyWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
            let toastView: UILabel = UILabel()
            toastView.text = toastMessage
            toastView.textColor = UIColor.whiteColor()
            toastView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            toastView.textAlignment = .Center
            toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width / 1.3, 50.0)
            toastView.layer.cornerRadius = 10
            toastView.layer.masksToBounds = true
            toastView.center = keyWindow.center
            keyWindow.addSubview(toastView)
            UIView.animateWithDuration(3.0, delay: 0.0, options: .CurveEaseOut, animations: {() -> Void in
                toastView.alpha = 0.0
                }, completion: {(finished: Bool) -> Void in
                    toastView.removeFromSuperview()
            })
        })
    }
}
