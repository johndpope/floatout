//
//  floatStoryStore.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit

class StoryTagStore {
    
    var storyTagList = [Int: [String: [String: AnyObject]]] ()
    
    func add(storyTag: StoryTag){
        
        self.storyTagList[storyTag.id] = ["main":
                ["dateCreated": storyTag.dateCreated!,
                    "storyName": storyTag.storyName,
                    "storyOverview": storyTag.storyOverview
                ]]
    }
  
    func storyTagListCount() -> Int{
        return self.storyTagList.count
    }

}
