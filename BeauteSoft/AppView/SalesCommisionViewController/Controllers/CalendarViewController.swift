import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var onDateSelection: ((_ date: Date) -> Void)?
    var datePickerConstraints = [NSLayoutConstraint]()
    var initialDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = initialDate
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.center = view.center
    }
    
    @objc func handleDateSelection() {
        guard let picker = datePicker else { return }
        print("Selected date/time:", picker.date)
        onDateSelection?(picker.date)
        dismiss(animated: true)
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
