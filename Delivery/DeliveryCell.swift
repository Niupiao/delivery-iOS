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
    @IBOutlet weak var deliveryButton: UIButton!
    
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
    
    var deliveryButtonTag: Int = 0 {
        didSet {
            if deliveryButtonTag != oldValue {
                deliveryButton.tag = deliveryButtonTag
            }
        }
    }
    
    var deliveryButtonId: Int = 0 {
        didSet {
            if deliveryButtonId != oldValue {
                deliveryButton.restorationIdentifier = String(deliveryButtonId)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
