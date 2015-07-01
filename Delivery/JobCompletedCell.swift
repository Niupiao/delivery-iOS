//
//  JobCompletedCell.swift
//  Delivery
//
//  Created by Mohamed Soussi on 7/1/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import Foundation

class JobCompletedCell: UITableViewCell {
    

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var wageLabel: UILabel!
    
    var address: String = "" {
        didSet {
            if address != oldValue {
                addressLabel.text! = address
            }
        }
    }
    
    var wage: Double = 0 {
        didSet {
            if wage != oldValue {
                wageLabel.text = String(format:"%.0f", wage)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}