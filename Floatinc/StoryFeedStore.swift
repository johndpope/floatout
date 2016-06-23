//
//  StoryFeedStore.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-08.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation

class StoryFeedStore {
    
    var storyFeedList = [StoryFeed]()
    
    func add(storyFeed:StoryFeed){
        self.storyFeedList.append(storyFeed)
    }
    
    func storyFeedListCount() -> Int{
        return self.storyFeedList.count
    }
    
    func remove(storyFeed : StoryFeed) -> Int {
        var index = 0
        for storyFeedItem in self.storyFeedList{
            
            if(storyFeed.id == storyFeedItem.id){
                print ("remove from the storyFeedlist")
                storyFeedList.removeAtIndex(index)
                return index
            }
            index+=1
        }
        return -1
    }
    
    func updateStoryFeed(storyFeed: StoryFeed) -> Int {
        var index = 0;
        index = indexOfStoryFeed(storyFeed)
        if(index != -1){
            self.storyFeedList[index] = storyFeed
            return index
        }
        
        return -1
    }
    
   func indexOfStoryFeed(storyFeed: StoryFeed) -> Int {
        var index = 0
        for storyFeedItem in self.storyFeedList {
            if(storyFeed.id == storyFeedItem.id){
                print ("check this returning index of storyFeed")
                return index
            }
            
            index+=1
        }
        return -1
    }
    
    func indexOfStoryFeedFromStoryTag(storyTag: StoryTag) -> Int {
        var index = 0
        for storyFeedItem in self.storyFeedList {
            if(storyTag.id == storyFeedItem.id){
                print ("check this returning index of storyFeed")
                return index
            }
            
            index+=1
        }
        return -1
    }
    
    
    func storyFeedItemForId(id: String) -> StoryFeed? {
        for storyFeedItem in self.storyFeedList {
            if(id == storyFeedItem.id) {
                return storyFeedItem
            }
        }
        return nil
    }
    
    
}
    