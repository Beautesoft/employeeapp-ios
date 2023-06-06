//
//  AttendanceVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/17/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

//AttananceReport
//Api name
//Inputs siteCode and userID

import UIKit
import AVFoundation
class AttendanceVC: UIViewController,QRCodeReaderViewControllerDelegate {
    
    
    @IBOutlet weak var vwInfoHeightConst: NSLayoutConstraint!
    @IBOutlet weak var stackVwUseInfo: UIStackView!
    @IBOutlet weak var lblTapToScan: UILabel!
    @IBOutlet var stackViewRest: UIStackView!
    @IBOutlet var stackViewRoom: UIStackView!
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet var clockOutBtn: UIButton!
    @IBOutlet var clockInBtn: UIButton!
    @IBOutlet var roomingOutBtn: UIButton!
    @IBOutlet var roomingInBtn: UIButton!
    @IBOutlet var restOutBtn: UIButton!
    @IBOutlet var restInBtn: UIButton!
    //Bar code Reader
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            $0.showSwitchCameraButton = false
            $0.preferredStatusBarStyle = .lightContent
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    var clockBtn = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        vwInfoHeightConst.constant = 230
        let locale = UserDefaultsManager.locale
        if locale == "synthesis" || UserDefaultsManager.locale == "emmabelle" {
          
        }
        else {
            stackViewRest.isHidden = true
            stackViewRoom.isHidden = true
        }
        stackVwUseInfo.isHidden = true
        getAttendenceReport()
        // Do any additional setup after loading the view.
    }
    //Call Task Creation APi
      func getAttendenceReport(){
//        let parameter = ["siteCode": profile.siteCode ?? "","userID": profile.userID ?? ""] as [String:AnyObject]
          let parameter = [ "userID": profile.userID ?? ""] as [String:AnyObject]
        let url = "\(base)\(Apis.attananceReport)"
        WebService.shared.postDataFor(api: url, parameters: parameter) { (sucess,response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                result.forEach({ (dict) in
                    self.stackVwUseInfo.isHidden = false
                    self.vwInfoHeightConst.constant = 325
                    if let temp = dict["employeeName"] as? String {
                        self.lblEmpName.text = "Emp Name:             \(temp)"
                    }
                    if let temp = dict["status"] as? String {
                        self.lblStatus.text = "Status:                     \(temp)"
                    }
                    if let temp = dict["time"] as? String {
                    let time = Utility.shared.formattedStringFromGivenDate(fromFormat: "HH:mm:ss", toFormat: "h:mm:ss a", dateString: temp)
                        
                        self.lblTime.text = "Time:                        \(time)"
                    }
                    if let temp = dict["date"] as? String {
                      let date  = Utility.shared.formattedStringFromGivenDate(fromFormat: "dd/MM/yyyy", toFormat: "dd MMM, yyyy", dateString: temp)
                        self.lblDate.text = "Date:                        \(date)"
                    }
                    //Yoonus enforce clock in and out active by default
                    self.clockInBtn.isEnabled = true
                    self.clockOutBtn.isEnabled = true
                    let attnType = dict["attnType"] as? String
                    if attnType == "00" {
                        self.clockInBtn.isEnabled = false
                        self.clockOutBtn.isEnabled = true
                        
                        self.restInBtn.isEnabled = false
                        self.restOutBtn.isEnabled = true
                        
                        self.roomingInBtn.isEnabled = false
                        self.roomingOutBtn.isEnabled = true
                    } else if attnType == "01" {
                        self.clockInBtn.isEnabled = true
                        
                        self.clockOutBtn.isEnabled = false
                        self.restInBtn.isEnabled = false
                        self.restOutBtn.isEnabled = false
                        self.roomingInBtn.isEnabled = false
                        self.roomingOutBtn.isEnabled = false
                    } else if attnType == "02" {
                        self.clockInBtn.isEnabled = false
                        self.clockOutBtn.isEnabled = true
                        
                        self.restInBtn.isEnabled = false
                        self.restOutBtn.isEnabled = true
                        
                        self.roomingInBtn.isEnabled = false
                        self.roomingOutBtn.isEnabled = true
                        
                    } else if attnType == "03" {
                        self.clockInBtn.isEnabled = false
                        self.clockOutBtn.isEnabled = true
                        self.restInBtn.isEnabled = true
                        self.restOutBtn.isEnabled = false
                        self.roomingInBtn.isEnabled = false
                        self.roomingOutBtn.isEnabled = false
                    } else if attnType == "04" {
                        self.clockInBtn.isEnabled = false
                        self.clockOutBtn.isEnabled = true
                        
                        self.restInBtn.isEnabled = false
                        self.restOutBtn.isEnabled = true
                        
                        self.roomingInBtn.isEnabled = false
                        self.roomingOutBtn.isEnabled = true
                    } else if attnType == "05" {
                        self.clockInBtn.isEnabled = false
                        self.clockOutBtn.isEnabled = true
                        
                        self.restInBtn.isEnabled = false
                        self.restOutBtn.isEnabled = false
                        
                        self.roomingInBtn.isEnabled = true
                        
                        self.roomingOutBtn.isEnabled = false
                    } else {
                        self.clockInBtn.isEnabled = true
                        //Yoonus if no reply from the api for attntype, activata all
                        self.clockOutBtn.isEnabled = true
                        self.restInBtn.isEnabled = true
                        self.restOutBtn.isEnabled = true
                        self.roomingInBtn.isEnabled = true
                        self.roomingOutBtn.isEnabled = true

                    }
               })
            }
         }
      }
    
    private func showData(dict: NSDictionary) {
        
    }
    //MARK: button action
    @IBAction func clockOutBtnTap(_ sender: UIButton) {
        clockBtn = "in"
        //sender.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.clockOutBtn.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.restInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.singleButtonAlertWith(message: .custom("Clock Out" ) , completionOnButton: nil)
    }
    @IBAction func clockInBtnTap(_ sender: UIButton) {
        clockBtn = "out"
        //    "inDate":"2019-02-11",
        //    "inTime":"2019-02-11 01:01:06",
        //sender.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockInBtn.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.singleButtonAlertWith(message: .custom("Clock In" ) , completionOnButton: nil)
    }
    
    @IBAction func restInBtnTap(_ sender: UIButton) {
        clockBtn = "restin"
        //sender.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.clockOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restInBtn.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.restOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.singleButtonAlertWith(message: .custom("Rest In" ) , completionOnButton: nil)
    }
    @IBAction func restOutBtnTap(_ sender: UIButton) {
        clockBtn = "restout"
        //sender.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.clockOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restOutBtn.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.roomingInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.singleButtonAlertWith(message: .custom("Rest Out" ) , completionOnButton: nil)
    }
    @IBAction func roomingInBtnTap(_ sender: UIButton) {
        clockBtn = "roomingin"
        //sender.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.clockOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingInBtn.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.roomingOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.singleButtonAlertWith(message: .custom("roomInBtn. In" ) , completionOnButton: nil)
    }
    @IBAction func roomingOutBtnTap(_ sender: UIButton) {
        clockBtn = "roomingout"
        //sender.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.clockInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.clockOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.restOutBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingInBtn.setBackgroundImage(UIImage(named:"field"), for: .normal)
        self.roomingOutBtn.setBackgroundImage(UIImage(named:"signInBg"), for: .normal)
        self.singleButtonAlertWith(message: .custom("roomInBtn. Out" ) , completionOnButton: nil)
    }
    @IBAction func backBtnTap(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func barCodeScanBtnTap(_ sender: Any) {
        guard checkScanPermissions() else { return }
        lblTapToScan.isHidden = true
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate  = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        if clockBtn == "" {
          self.lblTapToScan.isHidden = false
          self.singleButtonAlertWith(message: .custom("Please select 'Clock In' or 'Clock Out'" ) , completionOnButton: nil)
        }else {
            self.lblTapToScan.isHidden = true
            present(readerVC, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        lblTapToScan.isHidden = false
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Permission's
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        self.dismiss(animated: true, completion: nil)
        //guard let resultDict = result.value.dictionary(), let qrCode = resultDict["qrCode"] as? String else {
            //return
        //}
        guard let qrCode = result.value as? String else {
            return
        }

        //Yoonus Add in device name
        //var iOSDeviceName = ""
        let phoneNumber = UIDevice.current.name as String
       //
        
        if self.clockBtn == "in" {
            let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd")
            let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd hh:mm:ss")
            self.markAttendance(attendanceType: "1", inDate: "", inTime: "", outDate: getCurrentDate, outTime: getCurrentTime, qrCode: qrCode, phoneNumber: phoneNumber)
        }else if self.clockBtn == "out" {
            let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd")
            let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd hh:mm:ss")
            self.markAttendance(attendanceType: "0", inDate: getCurrentDate, inTime: getCurrentTime, outDate: "", outTime: "", qrCode: qrCode, phoneNumber: phoneNumber)
        }
        else if self.clockBtn == "restin" {
            let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd")
            let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd hh:mm:ss")
            self.markAttendance(attendanceType: "2", inDate: getCurrentDate, inTime: getCurrentTime, outDate: "", outTime: "", qrCode: qrCode, phoneNumber: phoneNumber)
        }
        else if self.clockBtn == "restout" {
            let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd")
            let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd hh:mm:ss")
            self.markAttendance(attendanceType: "3", inDate: getCurrentDate, inTime: getCurrentTime, outDate: "", outTime: "", qrCode: qrCode, phoneNumber: phoneNumber)
        }
        else if self.clockBtn == "roomingin" {
            let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd")
            let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd hh:mm:ss")
            self.markAttendance(attendanceType: "4", inDate: getCurrentDate, inTime: getCurrentTime, outDate: "", outTime: "", qrCode: qrCode, phoneNumber: phoneNumber)
        }
        else if self.clockBtn == "roomingout" {
            let getCurrentDate = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd")
            let getCurrentTime = Utility.shared.getCurrentDateAndTime(format: "yyyy-MM-dd hh:mm:ss")
            self.markAttendance(attendanceType: "5", inDate: getCurrentDate, inTime: getCurrentTime, outDate: "", outTime: "", qrCode: qrCode, phoneNumber: phoneNumber)
        }
    }
    private func markAttendance(attendanceType: String, inDate: String, inTime: String, outDate: String, outTime: String, qrCode: String, phoneNumber: String) {
        //let parameter = ["attendanceType": attendanceType,"userID": profile.userID ?? "","siteCode": profile.siteCode ?? "", "inDate": inDate, "inTime": inTime, "outDate": outDate, "outTime": outTime , "qrCode": qrCode] as [String:AnyObject]
        let parameter = ["attendanceType": attendanceType,"userID": profile.userID ?? "","siteCode": profile.siteCode ?? "", "inDate": inDate, "inTime": inTime, "outDate": outDate, "outTime": outTime , "qrCode": qrCode, "phoneNumber": phoneNumber] as [String:AnyObject]
        let url = "\(base)\(Apis.markAttendance)"
        WebService.shared.postDataFor(api: url, parameters: parameter) { (sucess,response, msg) in
            self.singleButtonAlertWith(message: .custom("Attendance marked sucessfully") , completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
}
