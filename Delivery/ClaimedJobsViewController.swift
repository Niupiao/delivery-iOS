//
//  ClaimedJobsViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class ClaimedJobsViewController: UITableViewController, UITableViewDataSource {
    
    let pickupCellIdentifier = "ProgressCell"
    let deliveryCellIdentifier = "DeliveryCell"
    var jobsList: JobsList!
    var claimedJobs: [Job]!
    var unclaimedJobs: [Job]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsList = JobsList.jobsList
        unclaimedJobs = jobsList.unclaimedJobs
        claimedJobs = jobsList.claimedJobs
    }

    @IBAction func pickedUpPressed(sender: UIButton) {
        claimedJobs[sender.tag].pickedUp = true
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return jobsList.claimedJobs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let job = claimedJobs[indexPath.row]
        
        if(!job.pickedUp){
            let cell = tableView.dequeueReusableCellWithIdentifier(pickupCellIdentifier, forIndexPath: indexPath) as! ProgressCell
        
            
            cell.address = job.pickup_address
            cell.pickupWindow = job.pickup_available_time
            cell.pickUpButtonTag = indexPath.row
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(deliveryCellIdentifier, forIndexPath: indexPath) as! DeliveryCell
            
            cell.deliveryWindow = job.dropoff_available_time
            cell.deliveryAddress = job.dropoff_address
            cell.deliveryButtonTag = indexPath.row
            return cell
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        claimedJobs = JobsList.jobsList.claimedJobs
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let claimedVC = segue.destinationViewController as! JobDetailViewController
        let job = claimedJobs[indexPath.row]
        
        claimedVC.jobSelected = job
        claimedVC.navigationItem.title = String(job.ID)
    }


}
