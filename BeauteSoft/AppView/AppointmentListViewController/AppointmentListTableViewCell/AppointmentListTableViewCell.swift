import UIKit

class AppointmentListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    func setup(_ appointment: AppointmentListing) {
        timeLabel.text = appointment.startTime
        customerNameLabel.text = appointment.customerName
        itemNameLabel.text = appointment.itemName
        statusLabel.text = "Status: " + (appointment.apptStatus ?? "")
    }
    
}
