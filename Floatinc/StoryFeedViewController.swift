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
    var chutiya = 0
    
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
        let feed = fetchMedia?.storyFeedStore.storyFeedItemForId(self.storyFeedId!)
        let mediaListCount = (feed?.sizeMediaList())! - 1
        if  self.currentImage < mediaListCount  {
            self.currentImage += 1
            SetImageView(self.currentImage)
        } else {
            print("end of feed going back to the story")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func SetImageView(index: Int){
        let fetchMediaFeedList = fetchMedia?.storyTagUrlList[self.storyFeedId!]
        if self.currentImage < fetchMediaFeedList?.count {
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
                return
            }
        }
        //This will be executed only when gStorageUrl is nil or currentImageIndex is greater than fetchMediaFeedList
        self.fetchMedia!.fetchImageWithStoryFeedArrayIndex(self.storyFeedArrayIndex!, mediaListArrayIndex: currentImage, callback: imageFetchCallback)

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
    
}

