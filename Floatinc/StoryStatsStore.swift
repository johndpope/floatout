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
    
    var storyStatsDict = [String: [String: AnyObject]] ()
    
    func add(storyStat: StoryStats){
        self.storyStatsDict[storyStat.id] = ["ref": storyStat.ref!, "viewCount": storyStat.totalViews]
    }
}

////                var storyStatsDict = [String: [String: AnyObject]]? ()
//var item = ["ref": viewItem.ref, "viewCount": viewItem.childSnapshotForPath("totalViews").value as? Int ?? 0]
//self.storyStatsStore.storyStatsDict[viewItem.key] = item