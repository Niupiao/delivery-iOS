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
    var accessKey: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("userLoggedIn?") == nil {
            if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as? UIViewController {
                self.presentViewController(loginController, animated: true, completion: nil)
            }
        } else {
            let keychainWrapper = KeychainWrapper()
            accessKey = keychainWrapper.myObjectForKey(kSecValueData) as! String
        }
        
        
        // right thing to do here would be to get jobsList from server and assign it to unclaimedJobs
        jobsList = JobsList.jobsList
        if jobsList.unclaimedJobs.isEmpty {
            jobsList.unclaimedJobs = [Job(identifier: 1), Job(identifier: 2),Job(identifier: 3), Job(identifier: 4)]
        }
        unclaimedJobs = jobsList.unclaimedJobs
        for job in unclaimedJobs {
            job.wage = Double(arc4random_uniform(16))
            job.pickup_distance = Int(arc4random_uniform(32))
        }
    }
    
    // makes sure data is updated after a user claims a job
    override func viewWillAppear(animated: Bool) {
        unclaimedJobs = jobsList.unclaimedJobs
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sortButtonPressed(sender: UIBarButtonItem) {
        var sortByWage: Bool = false
        var sortByDistance: Bool = false
        var sortByTimeLeft: Bool =  false
        let controller = UIAlertController(title: "Sort", message: "Choose a sorting method", preferredStyle: .ActionSheet)
        
        let byWage = UIAlertAction(title: "By Wage", style: UIAlertActionStyle.Default, handler: { action in
            self.unclaimedJobs.sort() { $0.wage > $1.wage }
            self.tableView.reloadData()
        })
        
        let byDistance = UIAlertAction(title: "By Distance", style: UIAlertActionStyle.Default, handler: { action in
            self.unclaimedJobs.sort() { $0.pickup_distance < $1.pickup_distance }
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        controller.addAction(byWage)
        controller.addAction(byDistance)
        controller.addAction(cancel)
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return unclaimedJobs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! JobCell
        
        cell.distance = String(format: "%i", unclaimedJobs[indexPath.row].pickup_distance)
        cell.time = "2-4pm"
        cell.wage = String(format:"%.0f", unclaimedJobs[indexPath.row].wage)
        
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
