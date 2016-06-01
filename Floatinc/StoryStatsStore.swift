//
//  StoryStatsStore.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-02.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase


class StoryStatsStore {
    var storyStatsList = [StoryStats] ()
    
    func addItem(stat: StoryStats){
        self.storyStatsList.append(stat)
    }
    
//    var storyStatsDict = [String:[Int, Int]] ()
    
}