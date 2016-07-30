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
import MapKit
import CoreLocation

enum Media {
    case Photo(image: UIImage)
    case Video(url: NSURL)
}

class PreviewViewController: UIViewController, PBJVideoPlayerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var image : NSData!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonClose: UIButton!
    
    //Buttons that will change dynamically
    @IBOutlet weak var forwardButtonImage: UIImageView!
    @IBOutlet weak var finalUploadButton: UIButton!
    @IBOutlet weak var finalUploadImage: UIImageView!
    @IBOutlet weak var forwardButton: UIButton!
    
    
    @IBOutlet weak var textViewEdit: UITextView!
    
    //Reading the value from CameraViewController->StoryFeed Passing it to cameraViewController
    var storyTagStore : StoryTagStore!
//    var storyTagIdPicked : String?
    var location : CLLocation?

    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var aspectRatio: CGFloat = 1.0
    
    var viewFinderHeight: CGFloat = 0.0
    var viewFinderWidth: CGFloat = 0.0
    var viewFinderMarginLeft: CGFloat = 0.0
    var viewFinderMarginTop: CGFloat = 0.0
    
    var media: Media!
    var playerController: PBJVideoPlayerController!
    var overlay : UIView?
    
    var storyPickerVC : StoryPickerTableView?
    
     //getting or trying viewwithtext for snapshot
    @IBOutlet weak var imageTextView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //making the textView draggable
        let textViewGesture = UIPanGestureRecognizer(target: self, action: #selector(PreviewViewController.userDraggedTextView(_:)))
        self.textViewEdit.addGestureRecognizer(textViewGesture)
        self.textViewEdit.userInteractionEnabled = true
        
        self.textViewEdit.delegate = self

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

//        self.playerController.view.frame = CGRectMake(viewFinderMarginLeft, viewFinderMarginTop, viewFinderWidth, viewFinderHeight)
        
        self.playerController.view.frame = self.view.bounds
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
    
    
    //TextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func userDraggedTextView(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        self.textViewEdit.frame.origin.x = 0
        self.textViewEdit.frame.origin.y = loc.y
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 30;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "showStoryPicker" {
          
            if let storyListPreviewPickerVc = segue.destinationViewController as? StoryPickerTableView {
                
                storyListPreviewPickerVc.storyTagStore = self.storyTagStore
                storyListPreviewPickerVc.preferredContentSize = CGSizeMake(self.imageView.bounds.size.width-20, self.imageView.bounds.size.height-180)
                storyListPreviewPickerVc.popoverPresentationController!.delegate = self
                storyListPreviewPickerVc.popoverPresentationController?.sourceView = self.view
                storyListPreviewPickerVc.popoverPresentationController?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-20,0,0)
                
                self.imageTextView.userInteractionEnabled = false
//                self.buttonClose.hidden = true
                storyListPreviewPickerVc.popoverPresentationController?.passthroughViews = [self.view, self.imageView, self.imageTextView, self.buttonClose, self.forwardButtonImage, self.forwardButton, self.finalUploadImage, self.finalUploadButton]
                
                self.storyPickerVC = storyListPreviewPickerVc
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    private func toggleCameraButtons() {
        self.forwardButton.hidden = !self.forwardButton.hidden
        self.forwardButtonImage.hidden = !self.forwardButtonImage.hidden
        
        self.finalUploadButton.hidden = !self.finalUploadButton.hidden
        self.finalUploadImage.hidden = !self.finalUploadImage.hidden
        
    }
    
    @IBAction func forwardButtonAction(sender: UIButton) {
        //Need to toggle cam buttons
        self.toggleCameraButtons()
    }
    
    
    @IBAction func sendMedia(sender: UIButton) {
        
        let store: StoreImage = StoreImage()
        if image != nil {
            var selectedRow = 0
            //Have to get the row number from the storyPickerTableView
            if self.storyPickerVC != nil {
                selectedRow = self.storyPickerVC!.rowSelected()
            }
        
            let storyTagIdPicked = self.storyTagStore.storyTagList[selectedRow].id
            
            var descriptionText = ""
            
            //taking a screenShot and saving it as an image
            let textImage = self.view.pb_takeSnapshot(self.imageTextView)
            image = UIImageJPEGRepresentation(textImage, 1.0)
            //saving the text in firebase
            if let text = self.textViewEdit.text  {
                descriptionText = text
            }
            store.saveImage(image, mediaType: "image",
                            storyTag: storyTagIdPicked,
                            description: descriptionText,
                            location: self.location)
            
            performSegueWithIdentifier("unwindToStoryListViewSegue", sender: self)
        }
    }
}

extension UIView {
    
    func pb_takeSnapshot(textView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        textView.drawViewHierarchyInRect(textView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
