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
    var imagesList = [String]()
    var descriptionList = [String]()
    var locationList = [[Double]]()
    
    init(snapshot: FIRDataSnapshot){
        self.id = snapshot.key
        self.ref = snapshot.ref
    
        let enumerator = snapshot.children
        while let mediaRef = enumerator.nextObject() as? FIRDataSnapshot {
            let key = mediaRef.key
            var url : String = ""
            var description: String = ""
            var locationArray = [Double]()
            //Once all the urls become become no need to cover this case
            if let u = mediaRef.value as? String{
               url = u
            }
            else {
                url = mediaRef.value!["url"] as! String
                description = mediaRef.value!["description"] as! String
                if let location = mediaRef.value!["metadata"]??["location"] as? [String: Double] {
                    let latitude = location["latitude"]! as Double
                    let longitude = location["longitude"]! as Double
                    locationArray = [latitude, longitude]
                }
            }
            self.mediaList[key] = url
            self.imagesList.append(url)
            self.descriptionList.append(description)
            self.locationList.append(locationArray)
        }

    }
    
    func sizeMediaList() -> Int {
        return self.mediaList.count
    }
    
}