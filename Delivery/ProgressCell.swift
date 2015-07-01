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
    @IBOutlet weak var pickupButton: UIButton!
    
    
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
    
    var pickUpButtonTag: Int = 0 {
        didSet {
            if pickUpButtonTag != oldValue {
                pickupButton.tag = pickUpButtonTag
            }
        }
    }
    
    var pickupButtonId: Int = 0 {
        didSet {
            if pickupButtonId != oldValue {
                pickupButton.restorationIdentifier = String(pickupButtonId)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickupButton.setImage(UIImage(named:"checked-box"), forState:UIControlState.Disabled)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
