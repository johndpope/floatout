//
//  StoryStats.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StoryTagStats : NSObject {
    
    var id: String
    var totalViews: Int
    var ref: FIRDatabaseReference?
    
    init(snapshot: FIRDataSnapshot){
        self.id = snapshot.key
        self.totalViews = snapshot.childSnapshotForPath("totalViews").value as! Int
        self.ref = snapshot.ref
    }
}
