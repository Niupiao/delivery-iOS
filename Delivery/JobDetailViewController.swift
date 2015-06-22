//
//  JobDetailViewController.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    
    var jobSelected: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if jobSelected != nil {
            detailLabel.text! = "\(jobSelected)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
