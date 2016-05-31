//
//  storyListTableView.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase

class StoryListTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootRef = FIRDatabase.database().reference()
 
    
    @IBOutlet weak var tableView: UITableView!
    let storyList: FloatStoryStore = FloatStoryStore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        let storyTagsRef = self.rootRef.child("storyTags")
        let refHandle = storyTagsRef.observeEventType(FIRDataEventType.Value, withBlock: {
            snapshot in
            for item in snapshot.children{
                let storyTagMain = (item as! FIRDataSnapshot).childSnapshotForPath("main")
                let storyTag = StoryTag(snapshot: storyTagMain)
                print(storyTagMain)
                self.storyList.addStory(storyTag)
                self.tableView.reloadData()
            }
            }, withCancelBlock: {
                error in (print(error.description))
        })
        
        
        //Making the hashTag stories ready

//          storyList.initWithStories()
        
        //These two lines are mandatory for making the rows dynamic in height,
        //atleast the first one. Second is for performance.
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
//        self.navigationController?.navigationBarHidden = true
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyList.storyCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StoryListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoryListTableViewCell
        
        //set up the cell here like setting the image etc 
        let story = storyList.storyList[indexPath.row]
        cell.label.text = story.heading
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    @IBAction func recordStory(sender: UIButton) {
        print("ohhhh yeah baby record me all night all long")
        
    }
    
}
