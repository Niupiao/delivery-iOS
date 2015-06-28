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
    
    func buildRequest(path: String!, method: String, key: String!) -> NSMutableURLRequest {
        // 1. Create request URL from path
        let requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path)?format=json&key=\(key)")!
        var request = NSMutableURLRequest(URL: requestURL)
        
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
}

