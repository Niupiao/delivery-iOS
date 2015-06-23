//
//  JobDetailViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var claimButton: UIButton!
    
    var showClaimButton: Bool = false
    
    var jobSelected: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if jobSelected != nil {
            detailLabel.text! = "\(jobSelected)"
        }
        claimButton.hidden = !showClaimButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func claimButtonPressed(sender: UIButton) {
        let claimedJobs = JobsList.jobsList
        claimedJobs.addJob(jobSelected.ID)
    }
}
