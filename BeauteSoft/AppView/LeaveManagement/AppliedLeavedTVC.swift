//
//  AppliedLeavedTVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 31/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class AppliedLeavedTVC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAppliedDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgEmployee: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
