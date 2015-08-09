//
//  SignUpViewController1.swift
//  Delivery
//
//  Created by Mohamed Soussi on 8/7/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class SignUpViewController1: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var driversLicenseTF: UITextField!
    @IBOutlet weak var ssnTF: UITextField!
    @IBOutlet weak var vehicleModelTF: UITextField!
    @IBOutlet weak var registrationNumTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //assigning delegate
        driversLicenseTF.delegate = self
        ssnTF.delegate = self
        vehicleModelTF.delegate = self
        registrationNumTF.delegate = self
        
        //setting up view background
        contentView.backgroundColor = UIColor(patternImage: UIImage(named: "blurred-background")!)
        
        //setting up nextbutton
        nextButton.layer.cornerRadius = 10
        
        //watching out for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        scrollView.contentSize = contentView.frame.size
    }
    
    // MARK: - Managing keyboard
    
    func keyboardDidShow(aNotification: NSNotification){
        let info: NSDictionary = aNotification.userInfo!
        let kbSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        
        if let activeField = self.activeField {
            var viewFrame = activeField.superview!.frame
            viewFrame.size.height = viewFrame.size.height + kbSize.height
            activeField.superview!.frame = viewFrame
            scrollView.setContentOffset(CGPointMake(0.0, activeField.frame.origin.y - kbSize.height), animated: true)
        }
    }
    
    func keyboardWillHide(aNotification: NSNotification){
        if let navBarHeight = self.navigationController?.navigationBar.frame.height {
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
            let offset = navBarHeight + statusBarHeight
            scrollView.setContentOffset(CGPointMake(0.0, -offset), animated: true)
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func didTapTextField(sender: UITextField){
        sender.becomeFirstResponder()
    }
    
    @IBAction func didFinishEditingTextField(sender: UITextField){
        sender.resignFirstResponder()
    }
    
    // MARK: - Text View Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
}
