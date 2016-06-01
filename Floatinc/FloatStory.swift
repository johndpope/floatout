//
//  FloatStory.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StoryTag : NSObject {
    
    enum storyBucket{
        case College,Graduate
    }
    
    var heading: String
    var overview: String
    var bucket: storyBucket?
    var image: UIImage?
    var date: String?
    var id: String
    var ref: FIRDatabaseReference?
    
    init(heading: String, overview: String, bucket: storyBucket, id: String){
        self.heading = heading
        self.overview = overview
        self.bucket = bucket
        let rad = rand()
        self.id = "check\(rad)"
    }
    
    init(snapshot: FIRDataSnapshot){
        let snapshotMain = (snapshot).childSnapshotForPath("main")
        
        self.id = snapshot.key
        self.heading = snapshotMain.childSnapshotForPath("storyName").value as? String ?? ""
        self.overview = snapshotMain.childSnapshotForPath("storyOverview").value as? String ?? ""
        self.date = snapshotMain.childSnapshotForPath("dateCreated").value as? String
        self.bucket = .Graduate
        self.ref = snapshotMain.ref
 
    }
}
