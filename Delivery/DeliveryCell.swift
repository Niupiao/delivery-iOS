//
//  DeliveryCell.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/23/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class DeliveryCell: UITableViewCell {

    @IBOutlet weak var deliveryWindowLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var deliverySwitch: UISwitch!
    
    var deliveryWindow: String = "" {
        didSet {
            if deliveryWindow != oldValue {
                deliveryWindowLabel.text = deliveryWindow
            }
        }
    }
    
    var deliveryAddress: String = "" {
        didSet {
            if deliveryAddress != oldValue {
                deliveryAddressLabel.text = deliveryAddress
            }
        }
    }
    
    var isDelivered: Bool = false {
        didSet {
            if isDelivered != oldValue {
                deliverySwitch.setOn(isDelivered, animated: true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        deliverySwitch.setOn(isDelivered, animated: true)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
