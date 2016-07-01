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

class PreviewViewController: UIViewController, PBJVideoPlayerControllerDelegate, AKPickerViewDelegate, AKPickerViewDataSource, UITextFieldDelegate {
    
    var image : NSData!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var pickerView: AKPickerView!
    
    @IBOutlet weak var textField: UITextField!
    
    //Reading the value from CameraViewController->StoryFeed Passing it to cameraViewController
    var storyTagStore : StoryTagStore!
    var storyTagIdPicked : String?

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
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.font = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.interitemSpacing = 2.0
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        
        //textField delegate
        self.textField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        //textField draggable
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PreviewViewController.userDragged(_:)))
        self.textField.addGestureRecognizer(gesture)
        self.textField.userInteractionEnabled = true
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
    
    //AKPicker Data Source
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.storyTagStore.storyTagList.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.storyTagStore.storyTagList[item].storyName
    }
    
    // AKPicker Delegate
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        print("Your favorite city is \(self.storyTagStore.storyTagList[item].storyName)")
        self.storyTagIdPicked = self.storyTagStore.storyTagList[item].id
        
    }
    
    //AKPicker Label customization
    func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor(red: 243.0/255.0, green: 148.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        label.highlightedTextColor = UIColor.blackColor()
        label.backgroundColor = UIColor(red: 247.0, green: 166.0, blue: 160.0, alpha: 0.3)
    }
    
    //AKPicker margins
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(10, 30)
    }
    
    //TextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //dragging the textfield around
    func userDragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        self.textField.center = loc
        let x = self.textField.frame.maxX
        let y = self.textField.frame.maxY
        
        print("center: x: \(loc.x) y: \(loc.y)")
        print("x: \(x), y: \(y)")
        
        print("checking")

    }
    
    @IBAction func sendMedia(sender: UIButton) {
        
        let store: StoreImage = StoreImage()
        if image != nil {
            if self.storyTagIdPicked == nil {
              self.storyTagIdPicked = self.storyTagStore.storyTagList[0].id
            }
            
            if storyTagIdPicked != nil {
                
                //If the user wrote text then time to change the image
                if let text = self.textField.text {
                    let font = textField.font
                    let alpha = textField.alpha
                    let textColor = textField.textColor
                    let frame = textField.frame
                    
                    let editTextField = textField as! textFieldCustom
                    let editTextFieldStart = editTextField.editingRectForBounds(textField.bounds)

                    let textImage = textToImage(text,frameTextField: frame, inImage: self.imageView.image!,textFont: font, textColor: textColor, alpha: alpha, editTextFieldStart: editTextFieldStart, viewBound: self.view.bounds)
                  image =  UIImageJPEGRepresentation(textImage, 1.0)
                }
                
              store.saveImage(image, mediaType: "image", storyTag: self.storyTagIdPicked!)
              self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }



}

func textToImage(drawText: NSString,frameTextField: CGRect,  inImage: UIImage, textFont: UIFont?, textColor: UIColor?, alpha: CGFloat, editTextFieldStart: CGRect, viewBound: CGRect )->UIImage{
    
    //Setup the image context using the passed image.
    UIGraphicsBeginImageContextWithOptions(inImage.size, true, 0.0)
    
    //Setups up the font attributes that will be later used to dictate how the text should be drawn
    let textFontAttributes = [
        NSFontAttributeName: textFont!,
        NSForegroundColorAttributeName: textColor!,
        ]

    //Put the image into a rectangle as large as the original image.
    inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
    
   
    let displaceX = inImage.size.width - viewBound.size.width

    
    // Creating a point within the space that is as bit as the image.
    let xPos = frameTextField.origin.x + editTextFieldStart.origin.x + displaceX
    let yPos = frameTextField.origin.y + editTextFieldStart.origin.y

    let rect: CGRect = CGRectMake(xPos, yPos, editTextFieldStart.width, editTextFieldStart.height)
    

   
    //drawing the textField background.
    let color = UIColor.whiteColor().colorWithAlphaComponent(alpha)
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
    CGContextFillRect(UIGraphicsGetCurrentContext(), frameTextField)
    
    //Drawing the Text
    drawText.drawInRect(rect, withAttributes: textFontAttributes)

    // Create a new image out of the images we have created
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    
    // End the context now that we have the image we need
    UIGraphicsEndImageContext()
    
    //And pass it back up to the caller.
    return newImage
    
}







