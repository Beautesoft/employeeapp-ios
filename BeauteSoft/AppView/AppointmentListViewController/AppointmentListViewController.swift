import UIKit

class AppointmentListViewController: UIViewController {
    
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var date = Date()
    var staffCode = ""
    var staffName = ""
    var siteCode = "GCHQ"
    var appointmentArray = [AppointmentListing]()
    var siteList = [SiteListingOption]()
    let dummyTf = UITextField(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        getSiteListing()
        configureSitePicker()
        setupUI()
    }
    
    func configureSitePicker() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(dummyTf)
        dummyTf.inputView = pickerView
    }
    
    func getSiteListing() {
        let actionURL = "\(base)\(Apis.siteListing)"
        WebService.shared.getDataFrom(api: actionURL) { (sucess, response , msg) in
            if let result = response["result"] as? [[String:Any]] {
                result.forEach({ (dict) in
                    self.siteList.append(SiteListingOption(fromDictionary: dict))
                })
            }
        }
    }
    
    func setupUI() {
        tableView.register(UINib(nibName: "AppointmentListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        staffNameLabel.text = staffName
        dateLabel.text = getDateStringToDisplay()
        siteLabel.text = "GRACIEUX NAILS PTE LTD [GCHQ]"
        getAppointmentList()
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
    
    func getAppointmentList() {
        appointmentArray.removeAll()
        tableView.reloadData()
        let url = "\(baseDashboard)\(Apis.getCustomerAppointmentList2)"
        let params: [String : AnyObject] = [
            "empCode": staffCode,
            "siteCode": siteCode,
            "appointmentDate": getDateStringToSend()
        ] as [String : AnyObject]
        WebService.shared.postDataFor(api: url, parameters: params) { (sucess, response, msg) in
            do {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodedResult = try JSONDecoder().decode(AppointmentResponse.self, from: data)
                print(decodedResult)
                if let appointments = decodedResult.result?.first?.listing {
                    self.appointmentArray = appointments
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableHeightConstraint.constant = CGFloat(self.appointmentArray.count * 90)
                }
            } catch {
                print(error)
            }
            
        }
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
                    self.staffNameLabel.text = staffName
                    self.getAppointmentList()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionSite(_ sender: UIButton) {
        dummyTf.becomeFirstResponder()
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
                self.dateLabel.text = self.getDateStringToDisplay()
                self.getAppointmentList()
            }
        }
        present(calendarVC, animated: true, completion: nil)
    }
}

extension AppointmentListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppointmentListTableViewCell
        cell.setup(appointmentArray[indexPath.row])
        return cell
    }
}

extension AppointmentListViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return siteList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return siteList[row].itemDesc
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let site = siteList[row]
        siteLabel.text = site.itemDesc
        siteCode = site.itemCode ?? ""
        dummyTf.resignFirstResponder()
        getAppointmentList()
    }
    
}
