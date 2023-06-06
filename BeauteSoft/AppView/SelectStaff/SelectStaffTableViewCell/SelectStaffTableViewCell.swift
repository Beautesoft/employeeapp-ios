import UIKit

class SelectStaffTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func setup(_ staff: Staff) {
        name.text = staff.fullName
    }
    
}
