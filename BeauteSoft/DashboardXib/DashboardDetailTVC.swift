//
//  DashboardDetailCell.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 05/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class DashboardDetailTVC: UITableViewCell {

    @IBOutlet weak var lblInfo: UILabel!
    var item: Any?{
        didSet{
            showData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private func showData() {
    }
}
