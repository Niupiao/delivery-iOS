//
//  SignUpViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 8/3/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let vContraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[headerImageView(==headerHeight)]", options: nil, metrics: ["headerHeight":self.view.frame.height/3.0], views: ["headerImageView":headerImageView])
        self.view.addConstraints(vContraint)
        
        nextButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
