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
    var refresh: UIRefreshControl!
    
    let cellIdentifier = "JobCell"
    let httpHelper = HTTPHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up pull down to refresh
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        self.refresh.addTarget(self, action: "refreshTable", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        self.tableView.addSubview(refresh)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("userLoggedIn?") == nil {
            if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as? UIViewController {
                self.presentViewController(loginController, animated: true, completion: nil)
            }
        }
        
        let keychainWrapper = KeychainWrapper()
        accessKey = keychainWrapper.myObjectForKey("v_Data") as! String
        
        jobsList = JobsList.jobsList
        requestJobs(accessKey)
    }
    
    func refreshTable(){
        requestJobs(accessKey)
        self.refreshControl?.endRefreshing()
    }
    
    // makes sure data is updated after a user claims a job
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        let request = httpHelper.buildRequest("index", method: "GET", key: key, deliveryId: nil, status: nil)
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
            self.jobsList.unclaimedJobs = self.httpHelper.parseJson(responseDict!, completed: false)
            self.unclaimedJobs = self.jobsList.unclaimedJobs
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
            
    }
    
    // MARK: - Table View Data Source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the number of rows in the section.
        return unclaimedJobs != nil ? unclaimedJobs.count : 0
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
}
