//
//  TotalWageCell.swift
//  Delivery
//
//  Created by Mohamed Soussi on 7/1/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import Foundation

class TotalWageCell: UITableViewCell {
    
    @IBOutlet weak var totalWageLabel: UILabel!
    
    var totalWage: Double = 0 {
        didSet {
            if totalWage != oldValue {
                totalWageLabel.text = String(format: "%.0f", totalWage)
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
