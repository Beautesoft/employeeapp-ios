//
//  let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView             headerCell.lblRecommeded.text = "RECOMMENDED"             headerCell.btnViewAll.setTitle("VIEW ALL", for: .swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 23/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
