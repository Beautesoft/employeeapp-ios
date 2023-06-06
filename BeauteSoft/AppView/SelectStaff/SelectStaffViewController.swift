import UIKit

class SelectStaffViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isComingForAppointmentList = false
    var staffList = [Staff]()
    var onStaffSelection: ((_ staffName: String, _ staffCode: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SelectStaffTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        getStaffList()
    }
    
    func getStaffList(){
        let url = "\(baseDashboard)\(Apis.senseGetStaffMList)"
        let params: [String : AnyObject] = [
            "isActive": "",
            "staffName": "",
            "siteCode": "\(profile.siteCode ?? "")",
            "SiteListing": [["siteCode": "\(profile.siteCode ?? "")",]]
        ] as [String : AnyObject]
        WebService.shared.postDataFor(api: url, parameters: params) { (sucess, response, msg) in
            if let staffList = response["result"] as? [[String:Any]] {
                staffList.forEach({ (dict) in
                    self.staffList.append(Staff(staffDict: dict))
                })
                self.tableView.reloadData()
            }
            
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectStaffViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectStaffTableViewCell
        cell.setup(staffList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let staff = staffList[indexPath.row]
        if onStaffSelection == nil {
            if isComingForAppointmentList {
                let vc = AppointmentListViewController.instantiateFrom(storyboard: .appointmentList)
                vc.staffCode = staff.staffCode ?? ""
                vc.staffName = staff.fullName ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = SalesCommisionViewController.instantiateFrom(storyboard: .salesCommision)
                vc.staffCode = staff.staffCode ?? ""
                vc.staffName = staff.fullName ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if var controllers = navigationController?.viewControllers {
                controllers.remove(at: controllers.count-2)
                navigationController?.setViewControllers(controllers, animated: false)
            }
        } else {
            onStaffSelection?(staff.fullName ?? "", staff.staffCode ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
}

struct Staff: Codable {
    let firstName, lastName, staffCode, fullName: String?
    
    init(staffDict: [String: Any]) {
        firstName = staffDict["firstName"] as? String ?? ""
        lastName = staffDict["lastName"] as? String ?? ""
        staffCode = staffDict["staffCode"] as? String ?? ""
        fullName = (firstName ?? "") + " " + (lastName ?? "")
    }
}
