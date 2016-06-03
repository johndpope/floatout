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
    
    var storyName: String
    var storyOverview: String
    var bucket: storyBucket?
    var image: UIImage?
    var dateCreated: String?
    var id: Int
    var ref: FIRDatabaseReference?

    
    init(snapshot: FIRDataSnapshot){
        let snapshotMain = (snapshot).childSnapshotForPath("main")
        let intID = Int(snapshot.key)
        self.id = intID!
        self.storyName = snapshotMain.childSnapshotForPath("storyName").value as? String ?? ""
        self.storyOverview = snapshotMain.childSnapshotForPath("storyOverview").value as? String ?? ""
        self.dateCreated = snapshotMain.childSnapshotForPath("dateCreated").value as? String
        self.ref = snapshotMain.ref
 
    }
}
