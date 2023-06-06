import UIKit

class InvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceNumberWithCustomerNameLabel: UILabel!
    @IBOutlet weak var itemDescLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    
    func setup(_ invoiceDetail: Detail) {
        invoiceNumberWithCustomerNameLabel.text = (invoiceDetail.invoiceNo ?? "") + ", " + (invoiceDetail.invoiceDetails?.first?.custName ?? "")
        if let detailsArray = invoiceDetail.invoiceDetails {
            let arrayMap: Array = detailsArray.map( { String(describing: $0.itmDsc ?? "") })
            let joinedString: String  = arrayMap.joined(separator: "\n")
            itemDescLabel.text = joinedString
            
            let quantityArray: Array = detailsArray.map( { String(describing: $0.itmQty ?? 0) })
            let joinedQuantity: String  = quantityArray.joined(separator: "\n")
            quantityLabel.text = joinedQuantity
            
            let amountArray: Array = detailsArray.map( { String(describing: $0.itmAmnt ?? 0) })
            let joinedAmount: String  = amountArray.joined(separator: "\n")
            amountLabel.text = joinedAmount
            
            let commissionArray: Array = detailsArray.map( { String(describing: $0.itmCmtn ?? 0) })
            let joinedCommission: String  = commissionArray.joined(separator: "\n")
            commissionLabel.text = joinedCommission
        }
    }
    
}
