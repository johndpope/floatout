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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(self.latitude,
                                                          longitude: self.longitude, zoom: 12)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        
        self.view = mapView
    
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        marker.title = "Delhi"
        marker.snippet = "India"
        marker.map = mapView
    }
    
}

