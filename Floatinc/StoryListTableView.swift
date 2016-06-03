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
    var handle = UInt?()
    
    //Data stores
    //StoryListStore: Contains the storyTags, its references
    let storyTagStore: StoryTagStore = StoryTagStore()
    //StoryStatsStore
    let storyTagStatsStore: StoryTagStatsStore = StoryTagStatsStore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        storyTagsRef = self.rootRef.child("storyTags")
        storyTagStatsRef = self.rootRef.child("storyTagStats")
        
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
        let storyTagKey = self.storyTagStore.storyTagList[indexPath.row].id
        let storyTagStatsRefForKey = self.storyTagStatsStore.storyTagStatsList[indexPath.row].ref
        ////////Assuming right now that the object storyTagStats/StoryID/totalViews is already created and initialised to zero
        
        storyTagStatsRefForKey?.runTransactionBlock({ (currentData) -> FIRTransactionResult in
            if currentData.value != nil {
                var storyTagStatsObject = currentData.value as! [String:AnyObject]
                //reading the total number of views (totalViews)
                var totalViews = storyTagStatsObject["totalViews"] as! Int
                //Incrementing it with 1
                totalViews+=1
                //Appending to the storyTagStatsObject
                storyTagStatsObject["totalViews"] = totalViews
                //Writing currenData's value to be equal to the new object that is updated
                currentData.value = storyTagStatsObject
                //Hoping for it to work now
                return FIRTransactionResult.successWithValue(currentData)
            }
            return FIRTransactionResult.successWithValue(currentData)
        })
    }
    
    
    
    ////            //Update the number of totalViews:
    ////            storyTagStatsRef?.runTransactionBlock({(currentData: FIRMutableData) -> FIRTransactionResult in
    ////                if currentData.value != nil {
    ////                    var storyTagStatsID = currentData.value as! [String:AnyObject]
    ////                    //getting the totalViews
    ////                    var totalViews = storyTagStatsID["totalViews"] as? Int ?? 1
    ////                    totalViews += 1
    ////                    //update the value in the firebase as well
    ////                    storyTagStatsID["totalViews"] = totalViews
    ////                    currentData.value = storyTagStatsID
    ////                    return FIRTransactionResult.successWithValue(currentData)
    ////                }
    ////                return FIRTransactionResult.successWithValue(currentData)
    ////            })

    
    @IBAction func recordStory(sender: UIButton) {
        print("ohhhh yeah baby record me all night all long")
        
    }
    
}


//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        //getting the reference from the store
////        let storyID = self.storyListStore.storyList[indexPath.row].id
////        var storyTagStatsRef = self.storyStatsStore.storyStatsDict[storyID]?["ref"]
////        let uid = (FIRAuth.auth()?.currentUser?.uid)!
////
////        //create the object in FIREBASE if the storyStat for this story does not exist
////        //This is done only the first time the user clicks on the story
////        if storyTagStatsRef == nil{
////          storyTagStatsRef = rootRef.child("storyTagStats/\(storyID)")
////            //adding the totalViews
////            storyTagStatsRef!.updateChildValues(["totalViews":1])
////            //adding userViews
////            let userStatsobj = [uid : ["views": 1]]
////            storyTagStatsRef!.updateChildValues(["users": userStatsobj])
////        }
////        else {
////
////            //Update the number of totalViews:
////            storyTagStatsRef?.runTransactionBlock({(currentData: FIRMutableData) -> FIRTransactionResult in
////                if currentData.value != nil {
////                    var storyTagStatsID = currentData.value as! [String:AnyObject]
////                    //getting the totalViews
////                    var totalViews = storyTagStatsID["totalViews"] as? Int ?? 1
////                    totalViews += 1
////                    //update the value in the firebase as well
////                    storyTagStatsID["totalViews"] = totalViews
////                    currentData.value = storyTagStatsID
////                    return FIRTransactionResult.successWithValue(currentData)
////                }
////                return FIRTransactionResult.successWithValue(currentData)
////            })

////            var users = storyTagStatsID["users"] as? [String:[String:Int]] ?? [:]
////            //check if this user has ever entered here or not, this for tracking user views
////            if(users[uid] == nil){
////                print("MR NEW USSER")
////
////                //This is for the case when an user clicks on the story for the first Time.
////                storyTagStatsRef?.child!("users").updateChildValues([uid:["views": 1]])
////                storyTagStatsRef?.child!("totalViews").setValue((totalViews+1))
////
////            }
////
////            else {
////                print("welcome again you like this story eh, hot girls in it ? :P ")
////                //getting the values
////                var userViews = users[uid]?["views"] ?? 1
////                userViews += 1
////                //setting the values
////                users[uid]?["views"] = userViews
////                storyTagStatsID["users"] = users
////            }
//        }
//    }


//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        self.tableView.reloadData()
//    }