//
//  FetchMedia.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-15.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics
import SDWebImage

class FetchMedia {
    
    //google storage refs
    var gStorageRef : FIRStorageReference?
    var gStoryFeedRef : FIRStorageReference?
    var gStoryFeedStore: StoryFeedStore!
    let gStorage  = FIRStorage.storage()
    
    //firebase refs
    let rootRef = FIRDatabase.database().reference()
    let storyFeedRef : FIRDatabaseReference?
    
    //TODO:
    //This will have to be provided by another class that instantiates the store!
     let storyFeedStore: StoryFeedStore
    
    //FETCHMEDIA VARIABLES TO KEEP TRACK OF INDEXING ! 
    //This will have to update everytime you fetch something.
    //ID: beginning to end
    private var storyImageTracker = [String: Int]()
    
    private var cacheImageList = [String: [Int:NSURL?]]()
    
    init(storyFeedStore: StoryFeedStore) {
        self.gStorageRef = gStorage.referenceForURL("gs://floatout-2417e.appspot.com")
        self.gStoryFeedRef = gStorageRef!.child("storyFeed")
        self.storyFeedRef = rootRef.child("storyFeed")
        self.storyFeedStore = storyFeedStore
    }
    
    func getCacheCount(id: String) -> Int{
        if let count = self.storyImageTracker[id] {
            return count
        }
        return 0
    }
    
    func fetchImagesForStoryFeedArrayIndex(storyFeedIndexArray: Int, endIndex: Int) {
        //checking for bounds for start and end index
        
        let storyFeed = self.storyFeedStore.storyFeedList[storyFeedIndexArray]
        let id = storyFeed.id
    
        if storyImageTracker[id] == nil {
            storyImageTracker[id] = 0
        }

        let imagesList = storyFeed.imagesList
        
        for index in 0..<imagesList.count {
            if(index >= storyImageTracker[id] && index < endIndex){
                let fullPath = "\(id)/\(imagesList[index])"
                self.storyImageTracker[id]! += 1
                self.storeImageToCache(fullPath, id: id, atIndex: index, imageListCount: imagesList.count)
            } else {
                break
            }
        }
        
    }
    
    func fetchImageWithStoryFeedArrayIndex(storyFeedIndexArrary: Int, mediaListArrayIndex: Int, callback: ()->Void){
        let storyFeed = self.storyFeedStore.storyFeedList[storyFeedIndexArrary]
        let id = storyFeed.id
        let imagesList = storyFeed.imagesList
        
        let gRefImageUrl = imagesList[mediaListArrayIndex]
        let fullPath = "\(id)/\(gRefImageUrl)"
        
        if storyImageTracker[id] == nil {
            storyImageTracker[id] = 0
        } else {
            storyImageTracker[id]! += 1
        }
    
        self.storeImageToCache(fullPath, id: id, callback: callback, atIndex: mediaListArrayIndex, imageListCount: imagesList.count)
    }
    
    func fetchStartEnd(storyFeedIndexArray: Int, startIndex: Int, endIndex: Int) {
        //checking for bounds for start and end index
        print("fetching for future startingAt: \(startIndex) ending at: \(endIndex)")
        let storyFeed = self.storyFeedStore.storyFeedList[storyFeedIndexArray]
        let id = storyFeed.id
        
        if storyImageTracker[id] == nil {
            storyImageTracker[id] = 0
        }
        
        let imagesList = storyFeed.imagesList
        
        for index in 0..<imagesList.count {
            if(index >= startIndex &&  index < endIndex){
                let fullPath = "\(id)/\(imagesList[index])"
                self.storeImageToCache(fullPath, id: id, atIndex: index, imageListCount: imagesList.count)
                print("fetching for index: \(index)")
                storyImageTracker[id]! += 1
            } else if (index >= endIndex) {
                break
            }
        }
    }
    
    
    func storeImageToCache(fullPath: String, id: String, callback: (() -> Void)? = nil, atIndex: Int, imageListCount: Int){
        let imageRef = self.gStoryFeedRef!.child(fullPath)
        imageRef.downloadURLWithCompletion { (gStorageUrl, error) -> Void in
            if error != nil {
                print("cannot get the google storage link of the imagePath provided")
            } else {
                
                //Making a dataStructure with storyTagId and its gStorageUrls, this makes sure
                //That the images being stored are the same order as the imageList.
                if self.cacheImageList[id] != nil {
                    self.cacheImageList[id]![atIndex] = gStorageUrl!
                } else {
                    self.cacheImageList[id] = [atIndex: gStorageUrl!]
                }
                
                let manager : SDWebImageManager = SDWebImageManager()
                manager.downloadImageWithURL(gStorageUrl, options: SDWebImageOptions.HighPriority, progress: { (receivedSize, expectedSize) -> Void in
                    print("downloadASAP")
                    }, completed: { (image: UIImage!, error: NSError!, SDImageCacheType: SDImageCacheType!, finished: Bool, imageUrl: NSURL!) -> Void in
                        if image != nil && finished == true {
                            print("oh yeah baby I have an image with url: \(imageUrl)")
                            if (callback != nil) {
                                print("calling the callback to set the image")
                                callback!()
                            }
                        }
                })
            }
        }
    }
    
    func getCacheList(storyFeedId: String) -> [Int : NSURL?]? {
        return self.cacheImageList[storyFeedId]
    }
    
    func getGsImageUrl(storyFeedId: String, index: Int) -> NSURL? {
        if let url =  self.cacheImageList[storyFeedId]?[index]{
            return url
        }
        return nil
    }
    //remove the entire storyFeed
    func removeStoryFeed(storyFeedId: String) {
        self.cacheImageList.removeValueForKey(storyFeedId)
    }
    
    //remove stale urls from cacheImageList
    
    func removeUrlFromStoryFeed(urlList: [String], storyFeedId: String){
  
        for (key,url) in self.cacheImageList[storyFeedId]! {
            
            if(key >= urlList.count) {
                var present = false
                for imagePath in urlList {
                    if((url?.path?.containsString(imagePath) != false)){
                      present = true
                      break
                    }
                }
                
                if (present == false) {
                  self.cacheImageList[storyFeedId]!.removeValueForKey(key)
                  self.storyImageTracker[storyFeedId]! -= 1
                  
                }
            }
            else {
                if((url?.path?.containsString(urlList[key])) != false) {
                    continue
                } else {
                    self.cacheImageList[storyFeedId]!.removeValueForKey(key)
                    self.storyImageTracker[storyFeedId]! -= 1
                     
                }
            }
        }
    }

}
