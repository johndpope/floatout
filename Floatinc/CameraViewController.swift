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
    @IBOutlet weak var autoImage: UIImageView!
    
    let locationManager = CLLocationManager()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a storage reference from our storage service

        let currentCameraState = cameraManager.currentCameraStatus()
        cameraManager.cameraOutputQuality = .Medium
        cameraManager.writeFilesToPhoneLibrary = false
    
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
        
        
        self.mediaCaptureButton.setBackgroundImage(UIImage(named: "cameraButtonPressed"), forState: .Highlighted)
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
            let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        }
    
    @IBAction func takePicture(sender: AnyObject) {
    
        print("hello")
        switch (cameraManager.cameraOutputMode) {
        case .StillImage:
            cameraManager.capturePictureWithCompletion({ (capturedImage, error) in
                if let errorOccurred = error {
                    self.cameraManager.showErrorBlock(erTitle: "Error occured", erMessage: errorOccurred.localizedDescription)
                }
                    
                else {
                    if let capturedImageTaken = capturedImage {
                        let previewViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("previewViewController") as! PreviewViewController
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
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func flash(sender: UIButton) {
        self.cameraManager.changeFlashMode()
        print(self.cameraManager.flashMode)
        self.autoImage.hidden = true
        switch(self.cameraManager.flashMode) {
        case .On:
            print("flashModeOn")
            let flashOnImage = UIImage(named: "flashActive")
            sender.setImage(flashOnImage, forState: .Normal)
        case .Off:
            print("flashModeOff")
            let flashOffImage = UIImage(named: "flashInactive")
            sender.setImage(flashOffImage, forState: .Normal)
        case .Auto:
            print("flashModeAuto")
            let flashAutoImage = UIImage(named: "flashActive")
            sender.setImage(flashAutoImage, forState: .Normal)
            self.autoImage.hidden = false
        }
    }
    
    @IBAction func flipTheCamera(sender: UIButton) {
    
     cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.Front ? CameraDevice.Back : CameraDevice.Front
    }
    

    //MARK: ViewController
    
    func askForCameraPermissions() {
        cameraManager.askUserForCameraPermission { (permissionGranted) in
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
