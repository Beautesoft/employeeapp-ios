//
//  CashVoucherExpireHeader.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 05/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class CashVoucherExpireTVC: UITableViewCell {
    var item: Any?{
        didSet{
            showData()
        }
    }

    @IBOutlet weak var lblExpired: UILabel!
    @IBOutlet weak var lblVoucherUsed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func showData() {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
