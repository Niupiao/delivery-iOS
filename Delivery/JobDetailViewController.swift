//
//  JobDetailViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {
    
    @IBOutlet weak var claimButton: UIButton!
    
    //pickup information
    @IBOutlet weak var pickupDistanceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupWindowLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sellerPhoneLabel: UILabel!
    
    //delivery information
    @IBOutlet weak var deliveryDistanceLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var deliveryWindowLabel: UILabel!
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var buyerPhoneLabel: UILabel!
    
    var jobSelected: Job!
    var accessKey: String!
    
    let mapTask = MapTask()
    let httpHelper = HTTPHelper()
    let keychain = KeychainWrapper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if jobSelected != nil {
            //claimButton.hidden = jobSelected.claimed
            
            // filling out pickup info
            pickupDistanceLabel.text = "7 miles"
            pickupAddressLabel.text = jobSelected.pickup_address
            pickupWindowLabel.text = jobSelected.pickup_available_time
            sellerNameLabel.text = jobSelected.pickup_name
            sellerPhoneLabel.text = jobSelected.pickup_phone
            
            //filling up delivery info
            deliveryDistanceLabel.text = "7 miles"
            deliveryAddressLabel.text = jobSelected.dropoff_address
            deliveryWindowLabel.text = jobSelected.dropoff_available_time
            buyerNameLabel.text = jobSelected.dropoff_name
            buyerPhoneLabel.text = jobSelected.dropoff_phone
            
        }
        
        accessKey = keychain.myObjectForKey("v_Data") as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        claimButton.hidden = jobSelected.claimed == 1 ? true : false
    }
    
    @IBAction func claimButtonPressed(sender: UIButton) {
        claimJob(accessKey, deliveryId: jobSelected.ID)
        JobsList.jobsList.removeUnclaimedJob(jobSelected)
    }
    
    //MARK: - Server Communication
    
    func claimJob(key: String, deliveryId: Int){
        let request = httpHelper.buildRequest("claim", method: "GET", key: key, deliveryId: deliveryId, status: nil)
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
            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSDictionary
        })
    }
}
