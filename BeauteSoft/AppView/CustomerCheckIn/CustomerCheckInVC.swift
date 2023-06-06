//
//  CustomerCheckInVC.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 04/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit
import AVFoundation
class CustomerCheckInVC: UIViewController,QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var lblTapToScan: UILabel!
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionScanQrCode(_ sender: Any) {
        guard checkScanPermissions() else { return }
        lblTapToScan.isHidden = true
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate  = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
               // self.getCustomerCheckIn(qrCode: result.value)
            }
        }
         present(readerVC, animated: true, completion: nil)
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
        self.dismiss(animated: true, completion: {
            self.getCustomerCheckIn(qrCode: result.value)
        })
        
    }
    //GetDepartment List
    func getCustomerCheckIn(qrCode: String){
        let url = "\(baseDashboard)\(Apis.customerAppointment)\(profile.siteCode ?? "")&customerCode=\(qrCode)"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [String: Any] {
                    let vc = CustomerArrivedVC.instantiateFrom(storyboard: .customerCheckIn)
                    vc.dict = result as NSDictionary
                    self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
