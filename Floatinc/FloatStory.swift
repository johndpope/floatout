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
    
    init(heading: String, overview: String, bucket: storyBucket){
        self.heading = heading
        self.overview = overview
        self.bucket = bucket
    }
    
    init(snapshot: FIRDataSnapshot){
        self.heading = snapshot.childSnapshotForPath("storyName").value as! String
        self.overview = snapshot.childSnapshotForPath("storyOverview").value as! String
        self.date = snapshot.childSnapshotForPath("dateCreated").value as? String
        self.bucket = .College
    }
}
