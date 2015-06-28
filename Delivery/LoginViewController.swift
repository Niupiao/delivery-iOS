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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let httpHelper = HTTPHelper()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityIndicator.hidden = true
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
          displayAlertMessage("Key Missing", alertDescription: "You must enter a key")
            return
        }
        
        if !keyField.text.isEmpty {
            loginRequest(keyField.text)
            loginButton.hidden = true
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            /*if defaults.objectForKey("userLoggedIn?") != nil {
                let navController = self.storyboard?.instantiateViewControllerWithIdentifier("navigator") as! UIViewController
                self.presentViewController(navController, animated: true, completion: nil)
                
            } else {
                var alert = UIAlertView()
                alert.title = "Invalid Key."
                alert.addButtonWithTitle("Try Again.")
                alert.show()
                return
            }*/
        }
    }
    
    func loginRequest(key: String!){
        let httpRequest = httpHelper.buildRequest("login", method: "GET", key: key)
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            self.activityIndicator.stopAnimating()
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage as String)
                
                return
            }
            
            var error:NSError?
            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSDictionary
            if let keyInvalid = responseDict["error"] as? String {
                self.displayAlertMessage("Invalid key", alertDescription: "The key you've entered is invalid.")
                self.activityIndicator.hidden = true
                self.loginButton.hidden = false
            } else {
                self.updateUserLoggedInFlag()
                self.saveKeyInKeychain(key)
            }
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
