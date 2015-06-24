//
//  Jobs.swift
//  Delivery
//
//  Created by シャノン スー on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class Job: Printable {
    
    var ID = 10;
    var pickup_address = "Seller Address";
    var pickup_available_time = "All the time";
    var pickup_name = "Foo";
    var pickup_phone = "111-111-1111";
    
    var dropoff_address = "Buyer Address";
    var dropoff_available_time = "Never";
    var dropoff_name = "Bar";
    var dropoff_phone = "222-222-2222";
    
    var expiration_time = "10:10:10 20/06/2015";
    var bounty = 10.0;
    var amount_due = 10.0;
    var item_name = "item_name";
    var item_quantity = 1;
    
    var claimed = false;
    var pickedUp = false
    var delivered = false
    
    var description: String {
        return "Pickup address: \(pickup_address)\nPickup name: \(pickup_name)\nPickup phone#: \(pickup_phone)"
    }
    
    init(){
        
    }
    
    init (identifier: Int) {
        self.ID = identifier;
    }
}

class JobsList: NSObject {
    
    class var jobsList: JobsList {
        struct Singleton {
           static let instance = JobsList()
        }
        return Singleton.instance
    }
    
    // store jobs by IDs
    private(set) var claimedJobs: [Int]
    var unclaimedJobs: [Job]
    
    override init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedClaimedJobs = defaults.objectForKey("claimedJobs") as? [Int]
        claimedJobs = storedClaimedJobs != nil ? storedClaimedJobs! : []
        unclaimedJobs = []
    }
    
    func addJob(targetJobId: Int){
        if(!contains(claimedJobs, targetJobId)){
            claimedJobs.append(targetJobId);
            saveClaimedJobs()
        }
    }
    
    func removeJob(targetJobId: Int){
        if let jobIndex = find(claimedJobs, targetJobId) {
            claimedJobs.removeAtIndex(jobIndex)
            saveClaimedJobs()
        }
    }
    
    func saveClaimedJobs(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(claimedJobs, forKey: "claimedJobs")
        defaults.synchronize()
    }
    
}


