//
//  PreviewViewController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-05-28.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//


import UIKit
import PBJVideoPlayer
//import FLAnimatedImage
import AKPickerView_Swift

enum Media {
    case Photo(image: UIImage)
    case Video(url: NSURL)
}

class PreviewViewController: UIViewController, PBJVideoPlayerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AKPickerViewDelegate, AKPickerViewDataSource {
    
    var image : NSData!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonClose: UIButton!
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var pickerView: AKPickerView!
    
    let titles = ["Pickup Soccer 6vv6", "Run or Swim or gym", "Excite for Euro", "Kulfi it is!", "Best hangover cure", "its time to fifa"]
    
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.titles.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.titles[item]
    }
    //Delegate
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        print("Your favorite city is \(self.titles[item])")
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var aspectRatio: CGFloat = 1.0
    
    var viewFinderHeight: CGFloat = 0.0
    var viewFinderWidth: CGFloat = 0.0
    var viewFinderMarginLeft: CGFloat = 0.0
    var viewFinderMarginTop: CGFloat = 0.0
    
    var media: Media!
    var playerController: PBJVideoPlayerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["hello soccer", "euroooo time", "bragman"]
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
//        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.interitemSpacing = 2.0
        self.pickerView.maskDisabled = false
        self.pickerView.textColor = UIColor.lightGrayColor()
        self.pickerView.highlightedTextColor = UIColor.blackColor()
        self.pickerView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor(red: 243.0/255.0, green: 148.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        label.highlightedTextColor = UIColor.blackColor()
        label.backgroundColor = UIColor(red: 247.0, green: 166.0, blue: 160.0, alpha: 0.3)
    }
    
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(10, 30)
    }
    
    @IBAction func closePreview(sender: UIButton) {
        print("some one is trying to close me baby")
        self.dismissViewControllerAnimated(true, completion: nil)
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

    override func viewWillAppear(animated: Bool) {
        switch self.media! {
        case .Photo(let image): self.imageView.image = image
        case .Video(let url): self.playVideo(url)
        }
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
    

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func sendMedia(sender: UIButton) {
        
        let store: StoreImage = StoreImage()
        if image != nil {
          store.saveImage(image, mediaType: "image", storyTag: "2")
          self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
}
