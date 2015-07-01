//
//  HTTPHelper.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/26/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import Foundation

struct HTTPHelper {
    
    static let BASE_URL = "https://niupiaomarket.herokuapp.com/delivery"
    static let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    let mapTask = MapTask()
    
    func buildRequest(path: String!, method: String, key: String, deliveryId: Int?, status: String?) -> NSMutableURLRequest {
        var requestURL: NSURL!
        var request: NSMutableURLRequest!
        
        // 1. Create request URL from path
        if ((deliveryId == nil) && (status == nil)) {
            requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path)?format=json&key=\(key)")!
        } else if status == nil {
            requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path)?format=json&key=\(key)&delivery_id=\(deliveryId!)")!
        } else {
            requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path)?format=json&key=\(key)&delivery_id=\(deliveryId!)&status=\(status!)")!
        }
        request = NSMutableURLRequest(URL: requestURL)
        
        // 2. set http method and content type
        request.HTTPMethod = method

        return request
    }
    
    func sendRequest(request: NSURLRequest, completion:(NSData!, NSError!) -> Void) -> () {
        // Create an NSURLSession task
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(data, error)
                })
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(data, nil)
                    } else {
                        var jsonerror:NSError?
                        if let errorDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as? NSDictionary {
                            let responseError : NSError = NSError(domain: "HTTPHelperError", code: httpResponse.statusCode, userInfo: errorDict as? [NSObject : AnyObject])
                            completion(data, responseError)
                        }
                    }
                }
            })
        }
        // start task
        task.resume()
    }
    
    func getErrorMessage(error: NSError) -> NSString {
        var errorMessage : NSString
        
        // return correct error message
        if error.domain == "HTTPHelperError" {
            let userInfo = error.userInfo as NSDictionary!
            errorMessage = userInfo.valueForKey("message") as! NSString
        } else {
            errorMessage = error.description
        }
        
        return errorMessage
    }
    
    func parseJson(object: AnyObject, completed: Bool) -> Array<Job> {
        
        var list: Array<Job> = []
        
        if object is Array<AnyObject> {
            
            for json in object as! Array<AnyObject> {
                var job: Job = Job()
                job.ID = (json["id"] as AnyObject? as? Int) ?? 0
                job.item_name = (json["item_name"] as AnyObject? as? String) ?? ""
                job.item_quantity = (json["item_quantity"] as AnyObject? as? Int) ?? 0
                job.pickedUp = false
                job.claimed = (json["claimed"] as AnyObject? as? Int) ?? 0
                job.pickup_available_time = (json["seller_availability"] as AnyObject? as? String) ?? ""
                job.dropoff_available_time = (json["buyer_availability"] as AnyObject? as? String) ?? ""
                job.wage = (json["charge"] as AnyObject? as? Double) ?? 0
                job.pickup_address = (json["seller_address"] as AnyObject? as? String) ?? ""
                job.dropoff_address = (json["buyer_address"] as AnyObject? as? String) ?? ""
                job.pickup_phone = (json["seller_phone"] as AnyObject? as? String) ?? ""
                job.dropoff_phone = (json["buyer_phone"] as AnyObject? as? String) ?? ""
                job.deliveryInstruction = (json["delivery_instruction"] as AnyObject? as? String) ?? ""
                let delivered = (json["status"] as AnyObject? as? String) == "Delivered" ? true : false
                job.pickedUp = (json["status"] as AnyObject? as? String) == "In Transit" ? true : false
                getJobCoordinates(job)
                if !delivered && !completed {
                    list.append(job)
                }
                if delivered && completed {
                    list.append(job)
                }
            }
        }
        
        return list
    }
    
    //Getting Coordinates for Addresses
    func getJobCoordinates(job: Job){
        mapTask.geocodeAddress( job.pickedUp ? job.dropoff_address : job.pickup_address, withCompletionHandler: { (status, success) -> Void in
            if !success {
                println(status)
                
                if status == "ZERO_RESULTS" {
                    //do nothing
                }
            }
            else {
                job.location = CLLocationCoordinate2D(latitude: self.mapTask.fetchedAddressLatitude, longitude: self.mapTask.fetchedAddressLongitude)
            }
        })
    }

}

