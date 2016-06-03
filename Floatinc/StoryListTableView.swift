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
    
    //StoryListStore: Contains the storyTags, its references
    let storyTagListStore: StoryTagStore = StoryTagStore()
//    let storyStatsStore: StoryStatsStore = StoryStatsStore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let storyTagsRef = self.rootRef.child("storyTags")
//        let storyTagStatsRef = self.rootRef.child("storyTagStats")
        
        //This should be called when the first time the list is populated
        storyTagsRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
            snapshot in
            for item in snapshot.children {
                let storyTagItem = item as! FIRDataSnapshot
                
                //saving in the local datastore created in storylist
                let storyTag = StoryTag(snapshot: storyTagItem)
//                self.storyTagListStore.addStoryTag(storyTag)
                
                self.storyTagListStore.add(storyTag)
                
                
                
                //forcing a refresh on the table to reload the data
                self.tableView.reloadData()
            }
            }, withCancelBlock: {
                error in (print(error.description))
        })
        
        //This should be called when storyTag is updated such as a particular story name or its overview.
        storyTagsRef.observeEventType(.ChildChanged , withBlock: {(snapshot) in
            print("ohh lalala \(snapshot)")
            let storyTag = StoryTag(snapshot: snapshot)
            
            self.storyTagListStore.add(storyTag)
            print(self.storyTagListStore.sstoryTagList[storyTag.id])
            
        })
//        
//        storyTagStatsRef.observeEventType(.Value, withBlock: {
//            snapshot in
//            for item in snapshot.children{
//                let viewItem = item as! FIRDataSnapshot
//                //key: storyID children: "totalViews: . value = count
//                
//                //saving the in the local datastore's dictionary
//                let storyStatsItem = StoryStats(snapshot: viewItem)
//                self.storyStatsStore.add(storyStatsItem)
//                
//            }
//            }, withCancelBlock: {
//                error in (print(error.description))
//        })
        
        
        //These two lines are mandatory for making the rows dynamic in height,
        //atleast the first one. Second is for performance.
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return storyTagListStore.storyTagCount()
        return self.storyTagListStore.storyTagListCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StoryListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoryListTableViewCell
        
        //set up the cell here like setting the image etc
        //Adding 1 as keys index start with 1
        
        let index = indexPath.row + 1
        let main = storyTagListStore.sstoryTagList[index]?["main"]
        let name:String = main?["storyName"] as! String

        cell.label.text = name
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 4.0
        
        return cell
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
////            
//        
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
    
    @IBAction func recordStory(sender: UIButton) {
        print("ohhhh yeah baby record me all night all long")
        
    }
    
}
