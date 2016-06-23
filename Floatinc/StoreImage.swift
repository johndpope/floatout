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
    
    func saveImage(data: NSData, mediaType: String, storyTag: String) {
        
        let nameFirstPart = FIRAuth.auth()?.currentUser?.email
        let storyMedia = self.storyFeedRef!.child("\(storyTag)")
        let storyMediaKey = storyMedia.childByAutoId().key
        let fullName = "\(nameFirstPart!)\(storyMediaKey)"

        let gUrlName = "\(storyTag)/\(fullName).jpg"
        let saveRef = gStoryFeedRef!.child(gUrlName)
        
        //upload the file to gstore
        _ = saveRef.putData(data, metadata: nil){ metadata, error in
            if (error != nil) {
                print("error")
            }
            else {
                print("PhotoHasBeenUploaded. Done")
                //save to Firebase storyFeed
                let gStorageUrl = metadata?.name
                storyMedia.child(storyMediaKey).setValue(gStorageUrl)
                
                //save to Firebase storyTagStats contribution:
                let uid = FIRAuth.auth()?.currentUser?.uid
                let userFeed = self.storyTagStatsRef!.child("\(storyTag)/users/\(uid!)/contribution")
                userFeed.child(storyMediaKey).setValue(gStorageUrl)
                
                
            }
        }
    }
}
