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
    let unclaimedCellIdentifier = "UnclaimedJobsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
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
        let cell = tableView.dequeueReusableCellWithIdentifier(unclaimedCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel!.text = String(jobsList[indexPath.row].ID)
        cell.detailTextLabel!.text = jobsList[indexPath.row].pickup_address
        
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
