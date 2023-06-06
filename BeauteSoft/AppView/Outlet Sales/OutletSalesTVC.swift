//
//  OutletSalesTVC.swift
//  BeauteSoft
//
//  Created by Himanshu Singla on 27/04/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class OutletSalesTVC: UITableViewCell {

    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblTotalSale: UILabel!
    @IBOutlet weak var lblTotalTD: UILabel!
    @IBOutlet weak var lblTotalPersonDoingSale: UILabel!
    @IBOutlet weak var lblTotalPersonDoingTD: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
