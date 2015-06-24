//
//  ProgressCell.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/23/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {

    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pickupSwitch: UISwitch!
    
    var pickupWindow: String = "" {
        didSet {
            if pickupWindow != oldValue {
                pickupTimeLabel.text = pickupWindow
            }
        }
    }
    
    var address: String = "" {
        didSet {
            if address != oldValue {
                addressLabel.text = address
            }
        }
    }
    
    var isPickedUp: Bool = false {
        didSet {
            if isPickedUp != oldValue {
                pickupSwitch.setOn(isPickedUp, animated: true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pickupSwitch.setOn(false, animated: true)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
