import UIKit

class SalesCommisionViewController: UIViewController {
    
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalDayAmountLabel: UILabel!
    @IBOutlet weak var totalDayCommissionLabel: UILabel!
    @IBOutlet weak var amountTableView: UITableView!
    @IBOutlet weak var amountTableToggleButton: UIButton!
    @IBOutlet weak var amountTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var invoiceTableView: UITableView!
    @IBOutlet weak var invoiceTableToggleButton: UIButton!
    @IBOutlet weak var invoiceTableHeightConstraint: NSLayoutConstraint!
    
    var date = Date()
    var staffCode = ""
    var staffName = ""
    var salesData: SalesData?
    var amountInfoArray = [AmountInfo]()
    var inVoiceArray = [Detail]()
    var invoiceTableHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        invoiceTableView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            let contentHeight = invoiceTableView.contentSize.height
            invoiceTableHeight = contentHeight
            invoiceTableView.isHidden = !invoiceTableToggleButton.isSelected
        }

    }
    
    func setupUI() {
        amountTableView.register(UINib(nibName: "AmountInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        invoiceTableView.register(UINib(nibName: "InvoiceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")

        staffNameLabel.text = staffName
        dateLabel.text = getDateStringToDisplay()
        getSalesCommision()
    }
    
    func setSalesData() {
        
        // Adding all the values separately to avoid being detected by the SourceKitSercvice and Swift-frontEnd, update as per your own risk
        
        var sum = (salesData?.tdAmnt ?? 0)
        sum += (salesData?.fstTdAmnt ?? 0)
        sum += (salesData?.courseAmnt ?? 0)
        sum += (salesData?.singlAmnt ?? 0)
        sum += (salesData?.retailAmnt ?? 0)
        sum += (salesData?.ppAmnt ?? 0)
        totalDayAmountLabel.text = ": \(Double(round(100 * sum) / 100))"
        
        sum = (salesData?.tdCmtn ?? 0)
        sum += (salesData?.fstTdCmtn ?? 0)
        sum += (salesData?.courseCmtn ?? 0)
        sum += (salesData?.singlCmtn ?? 0)
        sum += (salesData?.retailCmtn ?? 0)
        sum += (salesData?.ppCmtn ?? 0)
        totalDayCommissionLabel.text = ": \(Double(round(100 * sum) / 100))"
        prepareAmountInfoArray()
        if let invoices = salesData?.details {
            inVoiceArray = invoices
            if invoices.count > 0 {
                invoiceTableHeightConstraint.constant = CGFloat(1000)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.invoiceTableHeightConstraint.constant = 0
                }
            }
            invoiceTableView.reloadData()
        }
        
    }
    
    func getSalesCommision(){
        amountInfoArray.removeAll()
        inVoiceArray.removeAll()
        invoiceTableView.reloadData()
        amountTableView.reloadData()
        amountTableHeightConstraint.constant = 0
        
        invoiceTableToggleButton.isSelected = false
        amountTableToggleButton.isSelected = false
        
        let url = "\(baseDashboard)\(Apis.salesCommsion)?empCode=\(staffCode)&date=\(getDateStringToSend())"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            do {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodedResult = try JSONDecoder().decode(SalesCommission.self, from: data)
                self.salesData = decodedResult.result
                DispatchQueue.main.async {
                    self.setSalesData()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getDateStringToSend() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func getDateStringToDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy EEEE"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionStaff(_ sender: Any) {
        if  let role = profile.role, role == .manager {
            let vc = SelectStaffViewController.instantiateFrom(storyboard: .selectStaff)
            vc.onStaffSelection = {[weak self] (staffName: String, staffCode: String) -> Void in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.staffName = staffName
                    self.staffCode = staffCode
                    self.setupUI()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func prepareAmountInfoArray() {
        if totalDayAmountLabel.text != ": 0.0" {
            amountInfoArray = [
                AmountInfo(amountLabel: "Treatment Done Amount", commissionLabel: "Treatment Done Commission", amount: "\(salesData?.tdAmnt ?? 0)", commissionAmount: "\(salesData?.tdCmtn ?? 0)", color: .darkText),
                AmountInfo(amountLabel: "Walking TD Amount", commissionLabel: "Walking TD Commission", amount: "\(salesData?.fstTdAmnt ?? 0)", commissionAmount: "\(salesData?.fstTdCmtn ?? 0)", color: .red),
                AmountInfo(amountLabel: "Package Amount", commissionLabel: "Package Commission", amount: "\(salesData?.courseAmnt ?? 0)", commissionAmount: "\(salesData?.courseCmtn ?? 0)", color: .brown),
                AmountInfo(amountLabel: "Single Amount", commissionLabel: "Single Commission", amount: "\(salesData?.singlAmnt ?? 0)", commissionAmount: "\(salesData?.singlCmtn ?? 0)", color: .orange),
                AmountInfo(amountLabel: "Retail Amount", commissionLabel: "Retail Commission", amount: "\(salesData?.retailAmnt ?? 0)", commissionAmount: "\(salesData?.retailCmtn ?? 0)", color: .purple),
                AmountInfo(amountLabel: "Prepaid Amount", commissionLabel: "Prepaid Commission", amount: "\(salesData?.ppAmnt ?? 0)", commissionAmount: "\(salesData?.ppCmtn ?? 0)", color: .green)
            ]
            amountTableView.reloadData()
        }
    }
    
    @IBAction func actionDate(_ sender: Any) {
        let calendarVC = CalendarViewController.instantiateFrom(storyboard: .salesCommision)
        calendarVC.initialDate = date
        calendarVC.modalPresentationStyle = .overCurrentContext
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.onDateSelection = {[weak self] (date: Date) -> Void in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.date = date
                self.setupUI()
            }
        }
        present(calendarVC, animated: true, completion: nil)
    }
    
    @IBAction func hideShowAmountTableView(_ sender: Any) {
        amountTableToggleButton.isSelected.toggle()
        amountTableHeightConstraint.constant = amountTableToggleButton.isSelected
        ? CGFloat(80 * amountInfoArray.count)
        : 0
    }
    
    @IBAction func hideShowInvoiceTableView(_ sender: Any) {
        invoiceTableView.isHidden = false
        invoiceTableToggleButton.isSelected.toggle()
        invoiceTableHeightConstraint.constant = invoiceTableToggleButton.isSelected
        ? invoiceTableHeight
        : 0
    }

}

extension SalesCommisionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == invoiceTableView
        ? inVoiceArray.count
        : amountInfoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == invoiceTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvoiceTableViewCell
            cell.setup(inVoiceArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AmountInfoTableViewCell
            cell.setup(amountInfoArray[indexPath.row])
            return cell
        }
    }
}
