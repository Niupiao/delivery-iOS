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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func keyboardWillShow(aNotification: NSNotification){
        let info: NSDictionary = aNotification.userInfo!
        let kbSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        
        let contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var viewFrame = self.contentView.frame
        viewFrame.size.height = viewFrame.size.height - kbSize.height
        println(contentView.frame.height)
        println(viewFrame.height)
        if let activeField = activeField {
            if(!viewFrame.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Action Methods
    
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
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
}
