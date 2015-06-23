//
//  JobsListViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobsListViewController: UITableViewController, UITableViewDataSource {
    
    var unclaimedJobs: JobsList!
    var jobsList: [Job]!
    let cellIdentifier = "JobCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // right thing to do here would be to get jobsList from server and assign it to unclaimedJobs
        JobsList.jobsList.unclaimedJobs = [Job(identifier: 1), Job(identifier: 2)]
        jobsList = JobsList.jobsList.unclaimedJobs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return jobsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! JobCell
        
        cell.distance = "7 miles"
        cell.time = "2-4pm"
        cell.bounty = "7 tug"
        
        return cell
        
    }
        
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let jobVC = segue.destinationViewController as! JobDetailViewController
        
            jobVC.jobSelected = jobsList[indexPath.row]
            jobVC.navigationItem.title = jobsList[indexPath.row].item_name
            jobVC.showClaimButton = true
    }
}
