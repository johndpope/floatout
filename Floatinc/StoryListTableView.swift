//
//  storyListTableView.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StoryListTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Firebase refs
    let rootRef = FIRDatabase.database().reference()
//    var storyTagsRef = FIRDatabaseReference()
    
    @IBOutlet weak var tableView: UITableView!
    let storyListStore: FloatStoryStore = FloatStoryStore()
    let storyStatsStore: StoryStatsStore = StoryStatsStore()
    
    var Tryref = FIRDatabaseReference()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        let storyTagsRef = self.rootRef.child("storyTags")
        let storyTagStatsRef = self.rootRef.child("storyTagStats")
        
        
        storyTagsRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
            snapshot in
            for item in snapshot.children {
                let storyTagItem = item as! FIRDataSnapshot
                
                //saving in the local datastore created in storylist
                let storyTag = StoryTag(snapshot: storyTagItem)
                self.storyListStore.addStory(storyTag)
                
                //forcing a refresh on the table to reload the data
                self.tableView.reloadData()
            }
            }, withCancelBlock: {
                error in (print(error.description))
        })
        
        storyTagStatsRef.observeEventType(.Value, withBlock: {
            snapshot in
            for item in snapshot.children{
                let viewItem = item as! FIRDataSnapshot
                //key: storyID children: "totalViews: . value = count
                
                //saving the in the local datastore
                let storyStatsItem = StoryStats(snapshot: viewItem)
                self.storyStatsStore.addItem(storyStatsItem)
                
            }
            }, withCancelBlock: {
                error in (print(error.description))
        })
        
        
        //These two lines are mandatory for making the rows dynamic in height,
        //atleast the first one. Second is for performance.
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyListStore.storyCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StoryListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoryListTableViewCell
        
        //set up the cell here like setting the image etc 
        let story = storyListStore.storyList[indexPath.row]
        cell.label.text = story.heading
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyID = storyListStore.storyList[indexPath.row].id
        
        //get the clicked story reference
            
            
        //Update the number of views:
        .runTransactionBlock { (currentData: FIRMutableData) -> FIRTransactionResult in
            if currentData.value != nil {
                var storyTagStatsID = currentData.value as![String:AnyObject]
                var totalViews = storyTagStatsID["totalViews"] as? Int ?? 0
                
                //increming the totalviews on the story
                totalViews += 1
                //update the value in the database as well
                storyTagStatsID["totalViews"] = totalViews
                currentData.value = storyTagStatsID
            }
            return FIRTransactionResult.successWithValue(currentData)
        }
        
    
        
        
        //This created the node if not there.
//        storyStats.updateChildValues(["totalViews":1])
    }
    
    @IBAction func recordStory(sender: UIButton) {
        print("ohhhh yeah baby record me all night all long")
        
    }
    
}
