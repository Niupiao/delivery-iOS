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
    var accessKey: String!
    
    let cellIdentifier = "JobCell"
    let httpHelper = HTTPHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("userLoggedIn?") == nil {
            if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as? UIViewController {
                self.presentViewController(loginController, animated: true, completion: nil)
            }
        }
        
        let keychainWrapper = KeychainWrapper()
        accessKey = keychainWrapper.myObjectForKey("v_Data") as! String
        
        // right thing to do here would be to get jobsList from server and assign it to unclaimedJobs
        jobsList = JobsList.jobsList
        /*
        if jobsList.unclaimedJobs.isEmpty {
            jobsList.unclaimedJobs = [Job(identifier: 1), Job(identifier: 2),Job(identifier: 3), Job(identifier: 4)]
        }
        unclaimedJobs = jobsList.unclaimedJobs
        for job in unclaimedJobs {
            job.wage = Double(arc4random_uniform(16))
            job.pickup_distance = Int(arc4random_uniform(32))
        }*/
        requestJobs(accessKey)
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
    
    // MARK: - Server Communication
    
    func requestJobs(key: String){
        let request = httpHelper.buildRequest("index", method: "GET", key: accessKey)
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
            self.jobsList.unclaimedJobs = self.parseJson(responseDict!)
            self.unclaimedJobs = self.jobsList.unclaimedJobs
            self.tableView.reloadData()
        })
            
    }
    
    // MARK: - Table View Data Source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the number of rows in the section.
        return unclaimedJobs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! JobCell
        
        cell.distance = String(format: "%i", unclaimedJobs[indexPath.row].pickup_distance)
        cell.time = "2-4pm"
        cell.wage = String(format:"%.0f", unclaimedJobs[indexPath.row].wage)
        
        return cell
        
    }
        
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let jobVC = segue.destinationViewController as! JobDetailViewController
        
            jobVC.jobSelected = unclaimedJobs[indexPath.row]
            jobVC.navigationItem.title = String(unclaimedJobs[indexPath.row].ID)
    }
    
    // MARK: - Helper Methods
    
    func parseJson(object: AnyObject) -> Array<Job> {
        
        var list: Array<Job> = []
        var job: Job = Job()
        
        if object is Array<AnyObject> {
        
            for json in object as! Array<AnyObject> {
                job.item_name = (json["item_name"] as AnyObject? as? String) ?? ""
                job.item_quantity = (json["item_quantity"] as AnyObject? as? Int) ?? 0
                job.pickedUp = false
                job.claimed = (json["claimed"] as AnyObject? as? Int) ?? 0
                job.pickup_available_time = (json["seller_availability"] as AnyObject? as? String) ?? ""
                job.dropoff_available_time = (json["buyer_availability"] as AnyObject? as? String) ?? ""
                job.wage = (json["charge"] as AnyObject? as? Double) ?? 0
                job.pickup_address = (json["seller_address"] as AnyObject? as? String) ?? ""
                job.dropoff_address = (json["buyer_address"] as AnyObject? as? String) ?? ""
                job.pickup_phone = (json["seller_phone"] as AnyObject? as? String) ?? ""
                job.dropoff_phone = (json["buyer_phone"] as AnyObject? as? String) ?? ""
                job.deliveryInstruction = (json["delivery_instruction"] as AnyObject? as? String) ?? ""
                list.append(job)
            }
        }
        
        return list
    }
}
