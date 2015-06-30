//
//  Jobs.swift
//  Delivery
//
//  Created by シャノン スー on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class Job: Printable, Equatable {
    
    var ID = 10;
    var deliveryInstruction: String = ""
    
    var pickup_distance = 0
    var pickup_address = "Seller Address"
    var pickup_available_time = "All the time"
    var pickup_name = "Foo"
    var pickup_phone = "111-111-1111"
    
    var dropoff_distance = 0
    var dropoff_address = "Buyer Address"
    var dropoff_available_time = "Never"
    var dropoff_name = "Bar"
    var dropoff_phone = "222-222-2222"
    
    var expiration_time = "10:10:10 20/06/2015"
    var wage = 10.0
    var item_name = "item_name"
    var item_quantity = 1
    
    var claimed = 0
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

func ==(lhs: Job, rhs: Job) -> Bool {
    return rhs.ID == lhs.ID
}

class JobsList: NSObject {
    
    class var jobsList: JobsList {
        struct Singleton {
           static let instance = JobsList()
        }
        return Singleton.instance
    }
    
    // store jobs by IDs
    var claimedJobs: Array<Job>
    var unclaimedJobs: Array<Job>
    
    override init() {
        // get stuff from database here?
        claimedJobs = [] //local
        unclaimedJobs = [] //updates sent to server often
    }
    
    func addJob(targetJob: Job){
        if(!contains(claimedJobs, targetJob)){
            claimedJobs.append(targetJob)
            //saveClaimedJob()
        }
    }
    
    func removeJob(targetJob: Job){
        if let jobIndex = find(claimedJobs, targetJob) {
            claimedJobs.removeAtIndex(jobIndex)
            //completeClaimedJob()
        }
    }
    
    func removeUnclaimedJob(targetJob: Job){
        if let jobIndex = find(unclaimedJobs, targetJob){
            unclaimedJobs.removeAtIndex(jobIndex)
        }
    }
    
    func saveClaimedJobs(){
        // save to database
    }
    
}


