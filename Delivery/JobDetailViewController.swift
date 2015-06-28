//
//  JobDetailViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {
    
    @IBOutlet weak var claimButton: UIButton!
    
    //pickup information
    @IBOutlet weak var pickupDistanceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupWindowLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sellerPhoneLabel: UILabel!
    
    //delivery information
    @IBOutlet weak var deliveryDistanceLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var deliveryWindowLabel: UILabel!
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var buyerPhoneLabel: UILabel!
    
    var jobSelected: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if jobSelected != nil {
            //claimButton.hidden = jobSelected.claimed
            
            // filling out pickup info
            pickupDistanceLabel.text = "7 miles"
            pickupAddressLabel.text = jobSelected.pickup_address
            pickupWindowLabel.text = jobSelected.pickup_available_time
            sellerNameLabel.text = jobSelected.pickup_name
            sellerPhoneLabel.text = jobSelected.pickup_phone
            
            //filling up delivery info
            deliveryDistanceLabel.text = "7 miles"
            deliveryAddressLabel.text = jobSelected.dropoff_address
            deliveryWindowLabel.text = jobSelected.dropoff_available_time
            buyerNameLabel.text = jobSelected.dropoff_name
            buyerPhoneLabel.text = jobSelected.dropoff_phone
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func claimButtonPressed(sender: UIButton) {
        let jobs = JobsList.jobsList
        jobs.addJob(jobSelected)
        jobSelected.claimed = 1// maybe unclaimedJobsList should be a database that's synced with server?
                                    // line doesn't seem to have a long term effect. jobSelected goes back to false when user closes app.
        jobs.removeUnclaimedJob(jobSelected)
    }
    
    override func viewWillAppear(animated: Bool) {
        claimButton.hidden = jobSelected.claimed == 1 ? true : false
    }
}
