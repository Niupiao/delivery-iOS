//
//  CompletedJobsViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 7/1/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class CompletedJobsViewController: UITableViewController, UITableViewDataSource {

    var jobsList: JobsList!
    var accessKey: String!
    var completedJobs: Array<Job>!
    var totalSalary: Double!
    var refresh: UIRefreshControl!
    
    let httpHelper = HTTPHelper()
    let completedJobCellIdentifier = "completedJobCell"
    let wageCellIdentifier = "totalCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Pull down to refresh.")
        self.refresh.addTarget(self, action: "refreshTable", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        self.tableView.addSubview(refresh)
        
        let keychainWrapper = KeychainWrapper()
        accessKey = keychainWrapper.myObjectForKey("v_Data") as! String
        
        jobsList = JobsList.jobsList
        completedJobs = jobsList.completedJobs
        totalSalary = 0
        requestCompleted(accessKey)
    }
    
    func refreshTable(){
        requestCompleted(accessKey)
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        completedJobs = jobsList.completedJobs
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return completedJobs.count == 0 ? 0 : 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Completed Jobs" : "Total Wage"
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else {
            return completedJobs.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(wageCellIdentifier) as! TotalWageCell
            
            cell.totalWage = totalSalary
            return cell
        } else {
            let job = completedJobs[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(completedJobCellIdentifier) as! JobCompletedCell
        
            cell.wage = job.wage
            cell.address = job.dropoff_address
            return cell
        }
    }
    
    // MARK: - Server Communication
    
    // Urtuu Server
    func requestCompleted(key: String){
        let request = httpHelper.buildRequest("claimed", method: "GET", key: key, deliveryId: nil, status: nil)
        httpHelper.sendRequest(request, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = errorMessage as String
                alert.show()
                
                return
            }
            
            var error:NSError?
            let responseDict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
            self.jobsList.completedJobs = self.httpHelper.parseJson(responseDict!, completed: true)
            self.completedJobs = self.jobsList.completedJobs
            self.totalSalary = 0
            for job in self.completedJobs {
                self.totalSalary = self.totalSalary + job.wage
            }
            self.tableView.reloadData()
        })
    }

}
