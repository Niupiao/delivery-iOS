//
//  JobCell.swift
//  Delivery
//
//  Created by Mohamed Soussi on 6/23/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    
    var distance: String  = "" {
        didSet {
            if distance != oldValue {
                distanceLabel.text = distance
            }
        }
    }
    
    var bounty: String = "" {
        didSet {
            if bounty != oldValue {
                bountyLabel.text = bounty
            }
        }
    }
    
    var time: String = "" {
        didSet {
            if time != oldValue {
                timeLabel.text = time
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
