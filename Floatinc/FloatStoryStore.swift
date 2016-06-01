//
//  floatStoryStore.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit


class FloatStoryStore {
    var storyList = [StoryTag] ()
    
    func addStory(story: StoryTag){
        self.storyList.append(story)
    }
    
    func storyCount() -> Int{
        return self.storyList.count
    }
    
//    func initWithStories() {
//        let hashOneStory = StoryTag(heading: "No, I snooze more",overview: "give us proofs as to what exactly is going wrong and where, get creative boys", bucket: .Graduate)
//        self.storyList.append(hashOneStory)
//        
//        let hashTwoStory = StoryTag(heading: "LCBO TIME, who is paying :P", overview: "Show off your shopping, or too broke like us :P ", bucket: .Graduate)
//        self.storyList.append(hashTwoStory)
//        
//        let hashThreeStory = StoryTag(heading: "Afternoon timmies run", overview: "What do you think when you are going to timmies, lets see that in videos, do you ever get confused as to what you will buy or is it the same shit", bucket: .Graduate)
//        self.storyList.append(hashThreeStory)
//        
//        let hashFourStory = StoryTag(heading: "Real Madrid vs Athletico", overview: "OKay real fans lets see you grin now", bucket: .Graduate)
//        self.storyList.append(hashFourStory)
//        
//        let hashFiveStory = StoryTag(heading: "Lets hit a club in DT", overview: "things that go in your backend thought process, balck shirt or who cares kuch hone toh nahi waala", bucket: .Graduate)
//        self.storyList.append(hashFiveStory)
//        
//        let hashSixStory = StoryTag(heading: "Standup Meeting", overview: "How often do you feel to skip the meeting or sleep in ? +1", bucket: .Graduate)
//        self.storyList.append(hashSixStory)
//        
//        let hashSevenStory = StoryTag(heading: "Wednesday open mike john mayer", overview: "Who feels like chilling in this awesome weather", bucket: .Graduate)
//        self.storyList.append(hashSevenStory)
//    }
}
