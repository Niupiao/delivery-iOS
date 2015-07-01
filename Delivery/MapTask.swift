//
//  MapTask.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/30/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import Foundation

class MapTask: NSObject {
    
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var lookupAddressResults: Dictionary<NSObject, AnyObject>!
    
    var fetchedFormattedAddress: String!
    
    var fetchedAddressLongitude: Double!
    
    var fetchedAddressLatitude: Double!
    
    override init() {
        super.init()
    }
    
    func geocodeAddress(address: String!, withCompletionHandler completionHandler: ((status: String, success: Bool) -> Void)) {
        if let lookupAddress = address {
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
            geocodeURLString = geocodeURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let geocodeURL = NSURL(string: geocodeURLString)
            
            var request: NSURLRequest = NSURLRequest(URL: geocodeURL!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 2)
            
            var response: NSURLResponse?
            var error: NSError?
            
            var data: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
            
            let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! Dictionary<NSObject, AnyObject>

            if error != nil {
                println("ERROR")
                
                completionHandler(status: "", success: false)
            } else {
                
                let status = dictionary["status"] as! String
                
                if status == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<NSObject, AnyObject>>
                        self.lookupAddressResults = allResults[0]
                
                    // Keep the most important values.
                    self.fetchedFormattedAddress = self.lookupAddressResults["formatted_address"] as! String
                    let geometry = self.lookupAddressResults["geometry"] as! Dictionary<NSObject, AnyObject>
                    self.fetchedAddressLongitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
                    self.fetchedAddressLatitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as! NSNumber).doubleValue
                
                    completionHandler(status: status, success: true)
                } else {
                    completionHandler(status: status, success: false)
                }
            }
        } else {
            completionHandler(status: "Address invalid.", success: false)
        }
    }
}