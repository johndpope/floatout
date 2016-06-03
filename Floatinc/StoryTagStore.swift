//
//  floatStoryStore.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit

class StoryTagStore {
    
    var storyTagList = [StoryTag]()
    
    func add(storyTag:StoryTag){
        self.storyTagList.append(storyTag)
    }
  
    func storyTagListCount() -> Int{
        return self.storyTagList.count
    }
    
    func remove(storyTag : StoryTag) -> Int {
        var index = 0
        for storyTagItem in self.storyTagList{
            
            if(storyTag.id == storyTagItem.id){
                print ("remove from the storyTaglist")
                storyTagList.removeAtIndex(index)
                return index
            }
            index+=1
        }
        return -1
    }
    
    func updateStoryTag(storyTag: StoryTag) -> Int {
        var index = 0;
        index = indexOfStoryTag(storyTag)
        if(index != -1){
            self.storyTagList[index] = storyTag
            return index
        }

        return -1
    }
    
    func indexOfStoryTag(storyTag: StoryTag) -> Int {
        var index = 0
        for storyTagItem in self.storyTagList{
    
            if(storyTag.id == storyTagItem.id){
                print ("check this")
                return index
            }
            
            index+=1
        }
        return -1
    }
    
}
