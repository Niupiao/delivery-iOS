//
//  GoogleMapsViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/25/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        var camera = GMSCameraPosition.cameraWithLatitude(47.92,
            longitude:106.92, zoom:6)
        mView.camera = camera
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Manager Delegate Methods
    

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
  
        if status == .AuthorizedWhenInUse {
            
         
            locationManager.startUpdatingLocation()
            
      
            mView.myLocationEnabled = true
            mView.settings.myLocationButton = true
        }
    }
    
 
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
     
            mView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
       
            locationManager.stopUpdatingLocation()
        }
    }

}
