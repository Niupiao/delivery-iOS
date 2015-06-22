//
//  Jobs.swift
//  Delivery
//
//  Created by シャノン スー on 6/22/15.
//  Copyright (c) 2015 NiuPiao. All rights reserved.
//

import UIKit

struct job {
    var seller_address = "Seller Address";
    var seller_available_time = "All the time";
    var seller_name = "Foo";
    var seller_phone = "111-111-1111";
    
    var buyer_address = "Buyer Address";
    var buyer_available_time = "Never";
    var buyer_name = "Bar";
    var buyer_phone = "222-222-2222";
    
    var expiration_time = "10:10:10 20/06/2015";
    var bounty = 10;
    var amount_due = 100;
    var item_name = "item_name";
    var item_quantity = 1;
}
    
class Jobs: NSObject {
    var jobs = [job]();
}
