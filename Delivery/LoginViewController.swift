//
//  LoginViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/23/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var keyField: UITextField!
    
    let httpHelper = HTTPHelper()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl){
        keyField.resignFirstResponder()
    }
    
    @IBAction func logginButtonPressed(sender: UIButton) {
        keyField.resignFirstResponder()
        
        if keyField.text.isEmpty {
            var alert = UIAlertView()
            alert.title = "You must enter a key."
            alert.addButtonWithTitle("Got it!")
            alert.show()
            return
        }
        
        if !keyField.text.isEmpty {
            loginRequest(keyField.text)
            
            if defaults.objectForKey("userLoggedIn?") != nil {
                let navController = self.storyboard?.instantiateViewControllerWithIdentifier("navigator") as! UIViewController
                self.presentViewController(navController, animated: true, completion: nil)
                
            } else {
                var alert = UIAlertView()
                alert.title = "Invalid Key."
                alert.addButtonWithTitle("Try Again.")
                alert.show()
                return
            }
        }
    }
    
    func loginRequest(key: String!){
        let httpRequest = httpHelper.buildRequest("login", method: "GET", key: key)
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage as String)
            }
            
            var error:NSError?
            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSDictionary
            self.updateUserLoggedInFlag()
            self.saveKeyInKeychain(key)
        })
    }
    
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }
    
    func saveKeyInKeychain(key: String){
        let keychainWrapper = KeychainWrapper()
        keychainWrapper.mySetObject(key, forKey: kSecValueData)
        keychainWrapper.writeToKeychain()
    }
    
    func updateUserLoggedInFlag(){
        defaults.setObject("loggedIn", forKey: "userLoggedIn?")
        defaults.synchronize()
    }

}
