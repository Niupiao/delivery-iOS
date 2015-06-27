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
    
    func buildRequest(path: String!, method: String) -> NSMutableURLRequest {
        // 1. Create request URL from path
        let requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path)")!
        var request = NSMutableURLRequest(URL: requestURL)
        
        // 2. set http method and content type
        request.HTTPMethod = method
        
        //setting format to json
        request.addValue("json", forHTTPHeaderField: "format")
        
        // 3. adding access key to key field
        let userKey = KeychainAccess.keyForUser("Access Key", service: "KeyChainService") as String? {
            //set key header
            request.addValue(userKey, forHTTPHeaderField: "key")
        }
        
        return request
    }
}