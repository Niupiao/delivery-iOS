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
    let jobsList = JobsList.jobsList
    
    var jobsCoordinates: Dictionary<String, CLLocationCoordinate2D>!
    var mapTask = MapTask()
    var claimedJobs: Array<Job>!
    var firstTimeLocating: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // enable location and buttonview on load
        mView.myLocationEnabled = true
        mView.settings.myLocationButton = true
        
        // observer that centers the map around the user's locatino
        mView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        
        // set this controller's claimedJobs instance
        claimedJobs = jobsList.claimedJobs
        
        // puts jobs markers on map
        for job in claimedJobs {
            var locationMarker = GMSMarker(position: job.location)
            locationMarker.appearAnimation = kGMSMarkerAnimationPop
            locationMarker.icon = job.pickedUp ? GMSMarker.markerImageWithColor(UIColor.blueColor()) : GMSMarker.markerImageWithColor(UIColor.redColor())
            locationMarker.map = mView
        }
        
    }
    
    // on load, centers around user's location
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if firstTimeLocating {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            mView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            mView.settings.myLocationButton = true
            
            firstTimeLocating = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        claimedJobs = jobsList.claimedJobs
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePressed(sender: UIBarButtonItem) {
        
        mView.clear()
        
        claimedJobs = jobsList.claimedJobs
        
        for job in claimedJobs {
            var locationMarker = GMSMarker(position: job.location)
            locationMarker.appearAnimation = kGMSMarkerAnimationPop
            locationMarker.icon = job.pickedUp ? GMSMarker.markerImageWithColor(UIColor.blueColor()) : GMSMarker.markerImageWithColor(UIColor.redColor())
            locationMarker.map = mView
        }

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
    
    // MARK: - Helper Methods
    
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "Maps", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        alertController.addAction(closeAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

