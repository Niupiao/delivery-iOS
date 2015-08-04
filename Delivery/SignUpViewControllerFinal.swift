//
//  SignUpViewControllerFinal.swift
//  Delivery
//
//  Created by Mohamed Soussi on 8/4/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class SignUpViewControllerFinal: UIViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let vContraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[headerImageView(==headerHeight)]", options: nil, metrics: ["headerHeight":self.view.frame.height/3.0], views: ["headerImageView":headerImageView])
        self.view.addConstraints(vContraint)
        
        finishButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
