//
//  JobsListViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobsListViewController: UITableViewController, UITableViewDataSource {
    
    var jobsList: JobsList!
    var unclaimedJobs: [Job]!
    let cellIdentifier = "JobCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // right thing to do here would be to get jobsList from server and assign it to unclaimedJobs
        jobsList = JobsList.jobsList
        if jobsList.unclaimedJobs.isEmpty {
            jobsList.unclaimedJobs = [Job(identifier: 1), Job(identifier: 2),Job(identifier: 3), Job(identifier: 4)]
        }
        unclaimedJobs = jobsList.unclaimedJobs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return unclaimedJobs.count
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
        
            jobVC.jobSelected = unclaimedJobs[indexPath.row]
            jobVC.navigationItem.title = String(unclaimedJobs[indexPath.row].ID)
    }
}
