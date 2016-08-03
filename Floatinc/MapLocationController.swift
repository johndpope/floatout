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
    
    @IBOutlet weak var map1: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding Gmaps
        let camera = GMSCameraPosition.cameraWithLatitude(self.latitude,longitude: self.longitude, zoom: 12)
        
        self.map1.camera = camera
        map1.myLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        
        let aGMSGeocoder : GMSGeocoder = GMSGeocoder()
        aGMSGeocoder.reverseGeocodeCoordinate(marker.position) { (GMSReverseGeocodeResponse, Error) in
            if Error != nil {
                marker.map = self.map1
                return
            }
            
            if let geoResponse = GMSReverseGeocodeResponse {
                let gmsAddress : GMSAddress = geoResponse.firstResult()!
                
                marker.snippet = gmsAddress.country
                marker.title = gmsAddress.locality
                marker.map = self.map1
            }
        }
    }

    @IBAction func close(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

