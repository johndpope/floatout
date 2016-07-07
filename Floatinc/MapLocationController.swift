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
    
    //Getting these values from the feed controller
    var latitude : Double!
    var longitude: Double!
    
//    var interactor: Interactor? = nil
//    let panRecognizer = UIPanGestureRecognizer()
    
    @IBOutlet weak var map1: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding Gmaps
        let camera = GMSCameraPosition.cameraWithLatitude(self.latitude,longitude: self.longitude, zoom: 12)
        
        self.map1.camera = camera
        map1.myLocationEnabled = true
        map1.settings.consumesGesturesInView = true
        
        //Adding gesture to map
//        panRecognizer.addTarget(self, action: #selector(MapLocationController.draggedView(_:)))
//        self.map1.addGestureRecognizer(panRecognizer)
        
        self.map1.userInteractionEnabled = true

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        marker.title = "Delhi"
        marker.snippet = "India"
        marker.map = map1
    }
    
//    func draggedView(sender: UIPanGestureRecognizer){
//        let percentThreshold:CGFloat = 0.3
//        
//        // convert y-position to downward pull progress (percentage)
//        let translation = sender.translationInView(view)
//        let verticalMovement = translation.y / view.bounds.height
//        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
//        let downwardMovementPercent = fminf(downwardMovement, 1.0)
//        let progress = CGFloat(downwardMovementPercent)
//        guard let interactor = interactor else { return }
//        
//        switch sender.state {
//        case .Began:
//            interactor.hasStarted = true
//            dismissViewControllerAnimated(true, completion: nil)
//        case .Changed:
//            interactor.shouldFinish = progress > percentThreshold
//            interactor.updateInteractiveTransition(progress)
//        case .Cancelled:
//            interactor.hasStarted = false
//            interactor.cancelInteractiveTransition()
//        case .Ended:
//            interactor.hasStarted = false
//            interactor.shouldFinish
//                ? interactor.finishInteractiveTransition()
//                : interactor.cancelInteractiveTransition()
//        default:
//            break
//        }
//
//    }

    @IBAction func close(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

