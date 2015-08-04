//
//  SignUpViewController5.swift
//  Delivery
//
//  Created by Mohamed Soussi on 8/4/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit
import MobileCoreServices

class SignUpViewController5: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var registrationImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    
    var lastChosenMediaType: String?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registrationImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let xLIVConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[registrationImageView]|", options: nil, metrics: nil, views: ["registrationImageView":registrationImageView])
        let xBVConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[bottomView]-(-1)-|", options: nil, metrics: nil, views: ["bottomView":bottomView])
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[registrationImageView(==screenWidth)]-0-[bottomView]-(-1)-|", options: nil, metrics: ["screenWidth":self.view.frame.size.width], views: ["registrationImageView":registrationImageView,"bottomView":bottomView])
        
        self.view.addConstraints(xLIVConstraint)
        self.view.addConstraints(xBVConstraint)
        self.view.addConstraints(vConstraints)
        
        takePictureButton.layer.cornerRadius = 10
        retakeButton.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 10
        bottomView.layer.borderColor = UIColor.grayColor().CGColor
        bottomView.layer.borderWidth = 0.25
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    
    // MARK: - Image Picker Controller Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                image = info[UIImagePickerControllerEditedImage] as? UIImage 
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Action Methods
    
    @IBAction func didPressToTakePicture(sender: UIButton){
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            pickMediaFromSource(sourceType)
        } // no need to treat case where camera not available, since if user is on this scree, means camer is available
    }
    
    // MARK: - Helper Methods
    
    func updateDisplay(){
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                registrationImageView.image = image!
                takePictureButton.hidden = true
                retakeButton.hidden = false
                nextButton.hidden = false
            }
        }
    }
    
    func pickMediaFromSource(sourceType: UIImagePickerControllerSourceType){
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.sourceType = sourceType
            picker.cameraDevice = .Rear
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
}
