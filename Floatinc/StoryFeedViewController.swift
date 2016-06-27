//
//  StoryFeedViewController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-15.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import PBJVideoPlayer
import SDWebImage

class StoryFeedViewController: UIViewController, PBJVideoPlayerControllerDelegate {
    
    var image : NSData?
    
    private  var currentImage = 0
    
    var storyFeedId : String?
    //will get this from storyTagListVC
    var fetchMedia : FetchMedia?
    var storyFeedArrayIndex: Int?
    
    //viewWillAppear will set these variables
    var feed: StoryFeed?
    var totalMediaListCount: Int?
    var cachedMediaFeedList: [NSURL]?
    
    @IBOutlet weak var imageView: UIImageView!
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var aspectRatio: CGFloat = 1.0
    
    var viewFinderHeight: CGFloat = 0.0
    var viewFinderWidth: CGFloat = 0.0
    var viewFinderMarginLeft: CGFloat = 0.0
    var viewFinderMarginTop: CGFloat = 0.0
    
    var media: Media?
    var playerController: PBJVideoPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func swipeToMain(sender: UISwipeGestureRecognizer) {
        swipeBack()
    }
    
    func  swipeBack() {
        if self.currentImage == 0 {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            self.currentImage = self.currentImage-1
            print ("Display the previous image")
            SetImageView(self.currentImage)
        }
    }
    
    
    @IBAction func nextImage(sender: UISwipeGestureRecognizer) {
        //Bounds
        //Get the count of the mediaList
        if  self.currentImage < self.totalMediaListCount!-1 {
            self.currentImage += 1
            SetImageView(self.currentImage)
        } else {
            print("end of feed going back to the story")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //CACHING ALGORITHM!
    //** 1 ** Total Images Taken ->
    //** 2 ** Current Image
    //** 3 ** TotalCachedCount: cachedMediaFeedList.count? | 0
    
    /*
     
     default var toBeCached = 3
     Need to calculate toBeCached:
     if currentImage + 3 > totalMediaListCount {
     toBeCached = totalMediaListCount - currentImage
     }
     if toBeCached + TotalCachedCount > totalMediaListCount {
     toBeCached = totalMediaListCount-totalCachedCount
     }
     */
    
    
    
    
    func toBeCached(windowSize: Int) -> Int {
//        var totalCachedCount = self.cachedMediaFeedList?.count ?? 0
        var totalCachedCount = fetchMedia?.storyTagUrlList[self.storyFeedId!]?.count
        var newWindowSize = windowSize
        if (self.currentImage + windowSize) > self.totalMediaListCount {
            newWindowSize = self.totalMediaListCount! - currentImage
        }
        if (windowSize + totalCachedCount!) > self.totalMediaListCount   {
            newWindowSize = self.totalMediaListCount! - totalCachedCount!
        }
        return newWindowSize
    }
    
    //5:startCount,5: windowSize ===== fetchImage from 5 to 10
    func preLoadSize(startIndex : Int, windowSize: Int) -> Int {

        var totalCachedCount = fetchMedia?.storyTagUrlList[self.storyFeedId!]?.count
        //self.totalMediaListCount
        var newWindowSize = windowSize
        //only for the first index
        if self.currentImage == 0 {
            if startIndex > totalCachedCount {
                newWindowSize += startIndex - totalCachedCount!
            }
        }
        //for all the common cases
        if (startIndex + windowSize) > self.totalMediaListCount {
            newWindowSize = self.totalMediaListCount! - startIndex
        }
        
        if newWindowSize < 0 {
            return 0
        }
        return newWindowSize
        
        
    }
    
    func SetImageView(index: Int){
        let fetchMediaFeedList = fetchMedia?.storyTagUrlList[self.storyFeedId!]
        
        if self.currentImage < fetchMediaFeedList?.count {
            
            //caching algo try2
            let buffer = 10
            let windowSize = 5
            let endIndex = self.currentImage + buffer
            //get 5-10 images if they exist
            var startIndex = self.currentImage + windowSize
            let newWindowSize = preLoadSize(startIndex, windowSize: windowSize)
            
            if newWindowSize > 0 {
                if self.currentImage == 0 {
                    if newWindowSize > windowSize {
                        startIndex = (self.fetchMedia?.storyTagUrlList[self.storyFeedId!]?.count)!
                        print("initial images have still not been cached, user clicked before")
                    }
                    //start caching images from startIndex to endIndex
                    self.fetchMedia?.fetchStartEnd(self.storyFeedArrayIndex!, startIndex: startIndex, endIndex: endIndex)
                }
                else if ((self.currentImage % 5) == 0) {
                    print ("modding 5!")
                    self.fetchMedia?.fetchStartEnd(self.storyFeedArrayIndex!, startIndex: startIndex, endIndex: endIndex)
                }
            }

            let gStorageUrl = fetchMediaFeedList?[self.currentImage]
            
            if gStorageUrl != nil {
                let manager : SDWebImageManager = SDWebImageManager()
                manager.downloadImageWithURL(gStorageUrl, options: SDWebImageOptions.HighPriority, progress: { (receivedSize, expectedSize) -> Void in
                    print("inside the feedVc onSwipeRight")
                    }, completed: { (image: UIImage!, error: NSError!, SDImageCacheType: SDImageCacheType!, finished: Bool, imageUrl: NSURL!) -> Void in
                        if image != nil && finished == true {
                            print("setting inside the feed on swipe")
                            self.media = Media.Photo(image: image)
                            if  let imageData = UIImageJPEGRepresentation(image, 1.0){
                                self.image = imageData
                                self.imageView.image = image
                            }
                        }
                })
                //Very important to return from here
                return
            }
        }
        
        //This will be executed only when gStorageUrl is nil or currentImageIndex is greater than fetchMediaFeedList
        self.fetchMedia!.fetchImageWithStoryFeedArrayIndex(self.storyFeedArrayIndex!, mediaListArrayIndex: currentImage, callback: imageFetchCallback)
//        let tryCache = toBeCached(3)
//        print("CHECKING SIZE:::: \(tryCache)")
//        self.fetchMedia!.fetchSome(self.storyFeedArrayIndex!, windowSize: tryCache)
    }
    
    func imageFetchCallback() -> Void {
        print("inside imageFetchCallback, will be setting the image now.")
        self.SetImageView(self.currentImage)
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.media != nil {
            switch self.media! {
            case .Photo(let image): self.imageView.image = image
            case .Video(let url): self.playVideo(url)
            }
        } else {
            print("no media present will need to set it up")
            //Setting up some variables
            self.feed = fetchMedia?.storyFeedStore.storyFeedItemForId(self.storyFeedId!)
            self.totalMediaListCount = (feed?.sizeMediaList())!
//            self.cachedMediaFeedList = fetchMedia?.storyTagUrlList[self.storyFeedId!]
            
            SetImageView(currentImage)
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func playVideo(url: NSURL) {
        print("display video for url : \(url.absoluteString)")
        self.playerController = PBJVideoPlayerController()
        self.playerController.delegate = self
        
        if screenWidth > screenHeight {
            aspectRatio = screenHeight / screenWidth * aspectRatio
            viewFinderWidth = self.view.bounds.width
            viewFinderHeight = self.view.bounds.height * aspectRatio
            viewFinderMarginTop *= aspectRatio
        } else {
            aspectRatio = screenWidth / screenHeight
            viewFinderWidth = self.view.bounds.width * aspectRatio
            viewFinderHeight = self.view.bounds.height
            viewFinderMarginLeft *= aspectRatio
        }
        
        self.playerController.view.frame = CGRectMake(viewFinderMarginLeft, viewFinderMarginTop, viewFinderWidth, viewFinderHeight)
        
        //        self.playerController.view.frame = self.view.bounds
        self.playerController.videoPath = url.absoluteString
        
        self.addChildViewController(self.playerController)
        self.view.insertSubview(self.playerController.view, atIndex: 0)
        
        self.playerController.videoFillMode = "AVLayerVideoGravityResizeAspectFill"
        self.playerController.didMoveToParentViewController(self)
    }
    

    func videoPlayerReady(videoPlayer: PBJVideoPlayerController!) {
        print("Video player is ready!")
        videoPlayer.playFromBeginning()
        videoPlayer.playbackFreezesAtEnd = true
    }
    
    func videoPlayerPlaybackDidEnd(videoPlayer: PBJVideoPlayerController!) {
        print("oh it ended")
        videoPlayer.playFromBeginning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

