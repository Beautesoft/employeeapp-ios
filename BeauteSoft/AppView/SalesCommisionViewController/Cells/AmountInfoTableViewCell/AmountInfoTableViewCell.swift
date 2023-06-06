import UIKit

class AmountInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var commissionTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var commissionAmountLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    func setup(_ amountInfo: AmountInfo) {
        amountTitleLabel.text = amountInfo.amountLabel
        commissionTitleLabel.text = amountInfo.commissionLabel
        amountLabel.text = amountInfo.amount
        commissionAmountLabel.text = amountInfo.commissionAmount
        colorLabel.backgroundColor = amountInfo.color.withAlphaComponent(0.8)
    }

}
