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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurred-background.png")!)
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
        }
    }
    
    // MARK: - Server communication
    
    func loginRequest(key: String!){
        let httpRequest = httpHelper.buildRequest("login", method: "GET", key: key, deliveryId: nil, status: nil)
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
                self.displayAlertMessage("Invalid key", alertDescription: "The key you entered is invalid.")
                self.activityIndicator.hidden = true
                self.loginButton.hidden = false
            } else {
                self.updateUserLoggedInFlag()
                self.saveKeyInKeychain(key)
                if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as? UIViewController {
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        })
    }
    
    //MARK: - Helper Methods
    
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
