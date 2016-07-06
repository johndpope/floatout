//
//  MapLocationController.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-07-05.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit
import GoogleMaps

class MapLocationController : UIViewController {
    
    var latitude : Double!
    var longitude: Double!
    var interactor: Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(self.latitude,
                                                          longitude: self.longitude, zoom: 12)
//        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//        mapView.myLocationEnabled = true
//        
//        self.view = mapView
//    
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
//        marker.title = "Delhi"
//        marker.snippet = "India"
//        marker.map = mapView
    }
    
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
    
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translationInView(view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .Began:
            interactor.hasStarted = true
            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finishInteractiveTransition()
                : interactor.cancelInteractiveTransition()
        default:
            break
        }
    }


    @IBAction func close(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
    }



}

