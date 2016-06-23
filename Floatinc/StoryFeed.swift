//
//  StoryFeed.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-08.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class StoryFeed :NSObject {
    
    var id: String
    var ref: FIRDatabaseReference?
    var mediaList = [String:String]()
    
    init(snapshot: FIRDataSnapshot){
        self.id = snapshot.key
        self.ref = snapshot.ref
    
        let enumerator = snapshot.children
        while let mediaRef = enumerator.nextObject() as? FIRDataSnapshot {
            let key = mediaRef.key
            let url = mediaRef.value as! String
            self.mediaList[key] = url
        }

    }
    
    func sizeMediaList() -> Int {
        return self.mediaList.count
    }
    
}