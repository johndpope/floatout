//
//  cameraViewController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-06.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import CameraManager


class CameraViewController: UIViewController {
    //Segue
    var storyFeedStore : StoryFeedStore!
    
    //MARK: Constants
    let cameraManager = CameraManager()
    
    //MARK: @IBOutlets
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var backToStoryButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    @IBOutlet weak var selfieToggleButton: UIButton!
    @IBOutlet weak var mediaCaptureButton: UIButton!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a storage reference from our storage service

        let currentCameraState = cameraManager.currentCameraStatus()
        print(currentCameraState)
        
        if currentCameraState == .NotDetermined {
            askForCameraPermissions()
        }
        else if currentCameraState == .Ready {
            addCameraToView()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraManager.resumeCaptureSession()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    //MARK: @IBActions
    
    @IBAction func backToStory(sender: AnyObject) {
        print("exiting the camera and going back to the storyList")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//    cameraManager.cameraOutputMode = cameraManager.cameraOutputMode == CameraOutputMode.VideoWithMic ? CameraOutputMode.StillImage : CameraOutputMode.VideoWithMic
//    
//    switch (cameraManager.cameraOutputMode) {
//    case .StillImage:
//    mediaCaptureButton.selected = false
//    mediaCaptureButton.backgroundColor = UIColor.purpleColor()
//    case .VideoWithMic, .VideoOnly:
//    print("hello still work under progress")
//    }
    
    @IBAction func mediaCaptureButtonTapped(sender: UIButton) {
    
        switch (cameraManager.cameraOutputMode) {
        case .StillImage:
            cameraManager.capturePictureWithCompletition({ (capturedImage, error) in
                if let errorOccurred = error {
                    self.cameraManager.showErrorBlock(erTitle: "Error occured", erMessage: errorOccurred.localizedDescription)
                }
                    
                else {
                    if let capturedImageTaken = capturedImage {
                        let previewViewController = PreviewViewController(nibName: "PreviewViewController", bundle: nil)
                        previewViewController.media = Media.Photo(image: capturedImageTaken)
                        self.presentViewController(previewViewController, animated: true, completion: nil)
                        
                        if  let imageData = UIImageJPEGRepresentation(capturedImageTaken, 1.0){
                            let store: StoreImage = StoreImage()
                            //Getting the number of pictures in the users local store
//                            var mediaCount = self.storyFeedStore.storyFeedItemForId("1")?.mediaList.count
//                            if mediaCount == nil {
//                                mediaCount = 0
//                            }
                            store.saveImage(imageData, mediaType: "image", storyTag: "1")
                        }
                    }
                }
                
            })
            
        case .VideoOnly, .VideoWithMic:
            print("work under progress")
        }
    }
    
    
    @IBAction func flipTheCamera(sender: UIButton) {
    
     cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.Front ? CameraDevice.Back : CameraDevice.Front
        
        switch (cameraManager.cameraDevice){
        case .Front:
            print("front camera on")
            let frontImage = UIImage(named: "selfie")
            sender.setImage(frontImage, forState: .Normal)
        case .Back:
            print ("back camera on")
            let backImage = UIImage(named: "storyCamera")
            sender.setImage(backImage, forState: .Normal)
        }
    }
    

    //MARK: ViewController
    
    func askForCameraPermissions() {
        cameraManager.askUserForCameraPermissions { (permissionGranted) in
            if permissionGranted {
                self.addCameraToView()
            }
        }
    }
    
    private func addCameraToView() {
        //initialising the camera with directly the video mode
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.StillImage)
        
        //Error checking
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
           
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in  }))
            
            self?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}