//
//  StoryStatsStore.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-02.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase


class StoryTagStatsStore {
    
//    var storyStatsDict = [String: [String: AnyObject]] ()
//    
//    func add(storyStat: StoryTagStats){
//        self.storyStatsDict[storyStat.id] = ["ref": storyStat.ref!, "viewCount": storyStat.totalViews]
//    }
    
    var storyTagStatsList = [StoryTagStats]()
    
    func add(storyTagStats: StoryTagStats){
        self.storyTagStatsList.append(storyTagStats)
    }
    
    func count() -> Int{
        return self.storyTagStatsList.count
    }
    
    func remove(storyTagStats: StoryTagStats){
        var index = 0
        for storyTagStatsItem in self.storyTagStatsList{
            
            if(storyTagStatsItem.id == storyTagStats.id){
                print ("remove from the StoryTagStatslist")
                storyTagStatsList.removeAtIndex(index)
            }
            index+=1
        }
    }
    
    func update(storyTagStats: StoryTagStats){
        let index = indexOfStoryTagStat(storyTagStats)
        if(index != -1){
            self.storyTagStatsList[index] = storyTagStats
        }
    }
    
    func indexOfStoryTagStat(storyTagStats: StoryTagStats) -> Int {
        var index = 0
        for storyTagStatsItem in self.storyTagStatsList{
            
            if(storyTagStats.id == storyTagStatsItem.id){
                print ("getting index storyTagStatsList")
                return index
            }
            
            index+=1
        }
        return -1
    }
    
    func indexOfStoryTag(storyTag:StoryTag) -> Int{
        var index = 0
        for storyTagStatsItem in self.storyTagStatsList{
            if(storyTagStatsItem.id == storyTag.id){
                print("lets check it")
                return index
            }
            
            index+=1
        }
        return -1
    }
    
    
    
    
}
