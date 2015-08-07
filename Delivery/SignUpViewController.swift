//
//  SignUpViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 8/3/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

protocol SignUpControllerDelegate {
    func didCancelSignUp(signUp: SignUpViewController)
}

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: SignUpControllerDelegate?
    var activeField: UITextField?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        usernameTF.delegate = self
        passwordTF.delegate = self
        passwordConfTF.delegate = self
        
        contentView.backgroundColor = UIColor(patternImage: UIImage(named: "blurred-background")!)
        
        nextButton.layer.cornerRadius = 10
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
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
    
    func keyboardWillHide(aNotification: NSNotification) {
        if let navBarHeight = self.navigationController?.navigationBar.frame.height {
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
            let offset = navBarHeight + statusBarHeight
            scrollView.setContentOffset(CGPointMake(0.0, -offset), animated: true)
        } else {
            scrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        if let delegate = self.delegate {
            delegate.didCancelSignUp(self)
        }
    }
    
    @IBAction func didTapTextfield(sender: UITextField) {
        sender.becomeFirstResponder()
    }
    
    @IBAction func didEndEditingTextfield(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
}
