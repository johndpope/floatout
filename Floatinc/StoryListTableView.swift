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
   //Reference to the table view
    @IBOutlet weak var tableView: UITableView!
    
    //Firebase refs
    let rootRef = FIRDatabase.database().reference()
    var storyTagsRef : FIRDatabaseReference!
    var storyTagStatsRef: FIRDatabaseReference!
    var storyFeedRef: FIRDatabaseReference?
    var handle = UInt?()
    
    //Data stores
    //StoryListStore: Contains the storyTags, its references
    let storyTagStore: StoryTagStore = StoryTagStore()
    //StoryStatsStore
    let storyTagStatsStore: StoryTagStatsStore = StoryTagStatsStore()
    //StoryFeedStore
    let storyFeedStore: StoryFeedStore = StoryFeedStore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        storyTagsRef = rootRef.child("storyTags")
        storyTagStatsRef = rootRef.child("storyTagStats")
        storyFeedRef = rootRef.child("storyFeed")
        
        //StoryTagStats Observers/////////////////////////////////////////////////////////////////////
        
        //Adding and setting up initially
        storyTagStatsRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let storyTagStats = StoryTagStats(snapshot:snapshot)
            self.storyTagStatsStore.add(storyTagStats)
        })
        
        //Should delete the refs whenever they are deleted
        storyTagStatsRef.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let storyTagStats = StoryTagStats(snapshot:snapshot)
            self.storyTagStatsStore.remove(storyTagStats)
            
        })
        
        //childChanged should update the stale refs
        storyTagStatsRef.observeEventType(.ChildChanged, withBlock: { (snapshot) in
            let storyTagStats = StoryTagStats(snapshot:snapshot)
            self.storyTagStatsStore.update(storyTagStats)
        
        })

        //StoryTags Observers////////////////////////////////////////////////////////////////////////////////////
        
        //ChildAdded for storyTags
        storyTagsRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let storyTag = StoryTag(snapshot: snapshot)
            self.storyTagStore.add(storyTag)
            let index = self.storyTagStore.storyTagListCount()-1
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        })
        
        //Call it when a storyTag gets updated.
        storyTagsRef.observeEventType(.ChildChanged, withBlock: {(snapshot) in
            let storyTag = StoryTag(snapshot: snapshot)
            let index = self.storyTagStore.updateStoryTag(storyTag)
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        })
        
        //Gets called when a soryTag is deleted
        storyTagsRef.observeEventType(.ChildRemoved, withBlock: {(snapshot) in
            let storyTag = StoryTag(snapshot: snapshot)
            //This will take O(n) you suck really and will delete it lets see
            let index = self.storyTagStore.remove(storyTag)
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        })
        
        //StoryFeed Observers/////////////////////////////////////////////////////////////////////////////////////
        
        //Adding and setting up initially
        storyFeedRef!.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let storyFeed = StoryFeed(snapshot:snapshot)
            self.storyFeedStore.add(storyFeed)
        })
        
        //Should delete the refs whenever they are deleted
        storyFeedRef!.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let storyFeed = StoryFeed(snapshot:snapshot)
            self.storyFeedStore.remove(storyFeed)
            
        })

        //childChanged should update the stale refs
        storyFeedRef!.observeEventType(.ChildChanged, withBlock: { (snapshot) in
            let storyFeed = StoryFeed(snapshot:snapshot)
            self.storyFeedStore.updateStoryFeed(storyFeed)
        })
    
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //These two lines are mandatory for making the rows dynamic in height,
        //atleast the first one. Second is for performance.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyTagStore.storyTagListCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StoryListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoryListTableViewCell
        
        cell.label.text = storyTagStore.storyTagList[indexPath.row].storyName
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyTag = self.storyTagStore.storyTagList[indexPath.row]
        
        //finding the index for getting the reference to the storyTagStatsStore
        //Then updating the totalViews on the story
        let index = self.storyTagStatsStore.indexOfStoryTag(storyTag)
        if(index != -1){
            let storyTagStatsRefForKey = self.storyTagStatsStore.storyTagStatsList[index].ref
            //Assuming right now that the object storyTagStats/StoryID/totalViews is already created and initialised to zero
            
            //updating the number of totaViews
            storyTagStatsRefForKey?.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                if currentData.value != nil {
                    var storyTagStatsObject = currentData.value as! [String:AnyObject]
                    
                    /*Reading the total number of views (totalViews)
                    Appending to the storyTagStatsObject, Writing currenData's
                    value to be equal to the new object that is updated*/
                    
                    var totalViews = storyTagStatsObject["totalViews"] as! Int
                    totalViews+=1
                    storyTagStatsObject["totalViews"] = totalViews
                    currentData.value = storyTagStatsObject
                    
                    return FIRTransactionResult.successWithValue(currentData)
                }
                return FIRTransactionResult.successWithValue(currentData)
            })
            
            let uid = FIRAuth.auth()!.currentUser!.uid
            let userStatsRef = storyTagStatsRefForKey?.child("users").child(uid)
            
            //Tracking number of views by an user
            userStatsRef?.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                if currentData.value != nil {
                    
                    var userStatsObject = currentData.value as? [String: AnyObject]
                   
                    //This checks if the users/uid object exists
                    if userStatsObject != nil {
                        let viewCount = userStatsObject!["views"] as? Int ?? 0
                        let newCount = viewCount + 1
                        
                        //This check if users/uid/views exists
                        if userStatsObject == nil {
                            let userViewsObject = ["views":newCount]
                            currentData.value = userViewsObject
                        }
                        else {
                            userStatsObject!["views"] = newCount
                            currentData.value = userStatsObject
                        }
                    }
                    //User has not opened a story or contributed to one.
                    else {
                        currentData.value = ["views": 1]
                    }
                    return FIRTransactionResult.successWithValue(currentData)
                }
                return FIRTransactionResult.successWithValue(currentData)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cameraSegue" {
            let cameraViewController = segue.destinationViewController as! CameraViewController
            cameraViewController.storyFeedStore = self.storyFeedStore
        }
    }
    
    @IBAction func recordStory(sender: UIButton) {
        print("recording is being pressed baby")
    }
}
