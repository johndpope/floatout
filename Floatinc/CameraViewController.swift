//
//  cameraViewController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-06-06.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import CameraManager
import SDWebImage
import MapKit
import CoreLocation

class CameraViewController: UIViewController, CLLocationManagerDelegate  {
    
    //Segue2
    var storyFeedStore : StoryFeedStore!
    var storyTagNames : [String]!
    var storyTagStore : StoryTagStore!
    
    //MARK: Constants
    let cameraManager = CameraManager()
    
    //MARK: @IBOutlets
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var backToStoryButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    @IBOutlet weak var selfieToggleButton: UIButton!
    @IBOutlet weak var mediaCaptureButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a storage reference from our storage service

        let currentCameraState = cameraManager.currentCameraStatus()
        cameraManager.cameraOutputQuality = .Medium
        print(currentCameraState)
        
        if currentCameraState == .NotDetermined {
            askForCameraPermissions()
        }
        else if currentCameraState == .Ready {
            addCameraToView()
        }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraManager.resumeCaptureSession()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
        locationManager.stopUpdatingLocation()
    }
    
    //location
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            var locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            print("locations = \(locValue.latitude) \(locValue.longitude)")
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
                        previewViewController.storyTagStore = self.storyTagStore
                        previewViewController.media = Media.Photo(image: capturedImageTaken)
                        if  let imageData = UIImageJPEGRepresentation(capturedImageTaken, 1.0){
                            previewViewController.image = imageData
                            previewViewController.location = self.locationManager.location
                        }
                        self.presentViewController(previewViewController, animated: true, completion: nil)
                    }
                }
            })
            
        case .VideoOnly, .VideoWithMic:
            print("work under progress")
        }
    }
    
    @IBAction func flash(sender: UIButton) {
        self.cameraManager.changeFlashMode()
        print(self.cameraManager.flashMode)
        switch(self.cameraManager.flashMode) {
        case .On:
            print("flashModeOn")
            let flashOnImage = UIImage(named: "flashOn")
            sender.setImage(flashOnImage, forState: .Normal)
        case .Off:
            print("flashModeOff")
            let flashOffImage = UIImage(named: "flashOff")
            sender.setImage(flashOffImage, forState: .Normal)
        case .Auto:
            print("flashModeAuto")
            let flashAutoImage = UIImage(named: "flashAuto")
            sender.setImage(flashAutoImage, forState: .Normal)
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = event!.allTouches()!.first {
            let position = touch.locationInView(self.view)
            print("what i just got touched in my butt")
            print("cameraDevice \(self.cameraManager.cameraDevice)")
            self.cameraManager.focus(position)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
