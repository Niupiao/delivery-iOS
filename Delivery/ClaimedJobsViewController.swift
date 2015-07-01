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
    let httpHelper = HTTPHelper()
    let keychain = KeychainWrapper()
    
    var jobsList: JobsList!
    var claimedJobs: [Job]!
    var unclaimedJobs: [Job]!
    var accessKey: String!
    var refresh: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Pull down to refresh.")
        self.refresh.addTarget(self, action: "refreshTable", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
        
        accessKey = keychain.myObjectForKey("v_Data") as! String
        
        jobsList = JobsList.jobsList
        unclaimedJobs = jobsList.unclaimedJobs
        claimedJobs = jobsList.claimedJobs
        requestClaimed(accessKey)
    }
    
    func refreshTable(){
        requestClaimed(accessKey)
        self.refresh.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        claimedJobs = jobsList.claimedJobs
        tableView.reloadData()
    }

    @IBAction func pickedUpPressed(sender: UIButton) {
        updateStatus(accessKey, deliveryId: sender.tag, status: "In%20Transit")
        
        // find job in claimed, set picked up to true
        if let index = find(claimedJobs, Job(identifier: sender.tag)){
            claimedJobs[index].pickedUp = true
        }
        sender.setImage(UIImage(named:"checked-box"), forState:UIControlState.Normal)
        claimedJobs = jobsList.claimedJobs
        tableView.reloadData()
    }
    
    @IBAction func deliveredPressed(sender: UIButton) {
        updateStatus(accessKey, deliveryId: sender.tag, status: "Delivered")
        jobsList.removeClaimedJob(Job(identifier: sender.tag))
        claimedJobs = jobsList.claimedJobs
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return claimedJobs != nil ? claimedJobs.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let job = claimedJobs[indexPath.row]
        
        if(!job.pickedUp){
            let cell = tableView.dequeueReusableCellWithIdentifier(pickupCellIdentifier, forIndexPath: indexPath) as! ProgressCell
        
            
            cell.address = job.pickup_address
            cell.pickupWindow = job.pickup_available_time
            cell.pickUpButtonTag = job.ID
            return cell
        } else {
            // if job is picked up but not delivered
            
            let cell = tableView.dequeueReusableCellWithIdentifier(deliveryCellIdentifier, forIndexPath: indexPath) as! DeliveryCell
            cell.deliveryWindow = job.dropoff_available_time
            cell.deliveryAddress = job.dropoff_address
            cell.deliveryButtonTag = job.ID
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let claimedVC = segue.destinationViewController as! JobDetailViewController
        let job = claimedJobs[indexPath.row]
        
        claimedVC.jobSelected = job
        claimedVC.navigationItem.title = String(job.ID)
    }
    
    // MARK: - Server Communication
    
    // Urtuu Server
    func requestClaimed(key: String){
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
            self.jobsList.claimedJobs = self.httpHelper.parseJson(responseDict!)
            self.claimedJobs = self.jobsList.claimedJobs
            self.tableView.reloadData()
        })
    }

    
    func updateStatus(key: String, deliveryId: Int, status: String){
        let request = httpHelper.buildRequest("status", method: "GET", key: key, deliveryId: deliveryId, status: status)
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
        })
    }
}
