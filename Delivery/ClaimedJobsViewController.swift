//
//  ClaimedJobsViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class ClaimedJobsViewController: UITableViewController {
    
    let cellIdentifier = "ProgressCell"
    var jobsList: JobsList!
    var claimedJobIds: [Int]!
    var unclaimedJobs: [Job]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsList = JobsList.jobsList
        unclaimedJobs = jobsList.unclaimedJobs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func findJobWithId(jobId: Int) -> Job? {
        var job = Job()
        for job in unclaimedJobs {
            if job.ID == jobId {
                return job
            }
        }
        return nil
    }


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return jobsList.claimedJobs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProgressCell
        let job = findJobWithId(claimedJobIds[indexPath.row])!
        
        cell.address = job.pickup_address
        cell.pickupWindow = job.pickup_available_time
        cell.isPickedUp = false
        return cell
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        claimedJobIds = JobsList.jobsList.claimedJobs
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let claimedVC = segue.destinationViewController as! JobDetailViewController
        let job = findJobWithId(claimedJobIds[indexPath.row])!
        
        claimedVC.jobSelected = job
        claimedVC.navigationItem.title = job.item_name
        claimedVC.showClaimButton = false
    }


}
