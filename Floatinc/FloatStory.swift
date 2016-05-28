//
//  FloatStory.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import UIKit

class Story : NSObject {
    
    enum storyBucket{
        case College,Graduate
    }
    
    var heading: String
    var overview: String
    var bucket: storyBucket
    var image: UIImage?
    
    init(heading: String, overview: String, bucket: storyBucket){
        self.heading = heading
        self.overview = overview
        self.bucket = bucket
    }
}
