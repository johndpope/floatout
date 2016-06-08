//
//  firebase.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-07.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class StoreImage {
    var gstorageRef : FIRStorageReference?
    var gstoryFeedRef : FIRStorageReference?
    var gstoryFeedStore: StoryFeedStore!
    let rootRef = FIRDatabase.database().reference()
    let storyFeedRef : FIRDatabaseReference?
    
    init() {
        let gstorage  = FIRStorage.storage()
        self.gstorageRef = gstorage.referenceForURL("gs://floatout-2417e.appspot.com")
        self.gstoryFeedRef = gstorageRef!.child("storyFeed")
        
        self.storyFeedRef = rootRef.child("storyFeed")
        
    }
    
 
    func saveImage(data: NSData, mediaType: String, storyTag: String, count: Int) {
        let nameFirstPart = FIRAuth.auth()?.currentUser?.email
        let newCount = count+1
        let fullName = "\(nameFirstPart)\(newCount)"
        //So can find the count of storyFeedMedia count
        let url = "\(storyTag)/\(fullName)"
        let saveRef = gstoryFeedRef!.child(url)

        
        //upload the file
        _ = saveRef.putData(data, metadata: nil){ metadata, error in
            if (error != nil) {
                print("error")
            }
            else {
                print("PhotoHasBeenUploaded. Done")
                let nameUrl = metadata?.name
                //save to Firebase
                //Getting localCount:
//                var obj = [newCount: nameUrl!]
//                self.storyFeedRef!.child(storyTag).setValue(obj)
                
                self.storyFeedRef!.child("\(storyTag)/\(newCount)").setValue(nameUrl!)
                
            }
        }
    }
    
    
}
