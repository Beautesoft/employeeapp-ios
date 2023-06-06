//
//  BankInViewController.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 28/07/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit

class BankInViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var txtFldEnterAmount: UITextField!
    @IBOutlet weak var enterAmount: UITextField!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastname: UILabel!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblFromAndTODate: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    @IBOutlet weak var lblBlanceInAcc: UILabel!
    @IBOutlet weak var sitePicker: UIPickerView!
    var selectedSite = ""
    var pic:UIImage?
    let imagePicker = UIImagePickerController()
    var isSelectedImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sitePicker.delegate = self
        self.sitePicker.dataSource = self
        self.sitePicker.reloadAllComponents()
        
        lblFirstName.text = (profile.firstName ?? "") + " " + (profile.lastName ?? "")
        //lblFirstName.text = profile.firstName ?? ""
        //lblLastname.text = profile.lastName ?? ""
        //lblLastname
        selectedSite = profile.siteCode ?? ""
        lblCurrentDate.text = Utility.shared.getCurrentDateAndTime(format: "dd/MM/yyyy")
        getBankInDetail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Methods to upload image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        picker.allowsEditing = true
        if let pickedImage = info[.originalImage] as? UIImage {
            
            picker.allowsEditing = true
            picker.delegate = self
            self.imgFile.contentMode = .scaleToFill
            self.imgFile.image = pickedImage
            pic = self.imgFile.image
            self.isSelectedImage = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePicker(_ imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - button action
    @IBAction func actionSelectFile(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        initiateImagePicker(imagePicker, isVideo: false, editingAllowed: true)
    }
    @IBAction func actionSubmit(_ sender: Any) {
        if txtFldEnterAmount.text == ""{
            singleButtonAlertWith(message: .custom("Please enter amount."))
        }else if !isSelectedImage {
            singleButtonAlertWith(message: .custom("Please select slip."))
        }else {
            postBankInDetail()
        }
    }
    
    //Get Bank in Detail
    func getBankInDetail() {
        //let url = "\(base)\(Apis.getBankInAmountBankIn)\(profile.siteCode ?? "")"

        let url = "\(base)\(Apis.getBankInAmountBankIn)\(selectedSite)"
        WebService.shared.getDataFrom(api: url) { (sucess, response, msg) in
            if let result = response["result"] as? [[String: Any]] {
                if let dict = result.first {
                    if let amount = dict["amount"] as? Double {
                      self.lblBlanceInAcc.text = "\(amount)"
                    }
                }
            }
        }
    }
    func postBankInDetail() {
        if pic != nil{
            //{"siteCode":"HS04","taskID":"25","userID":""}
            let imgdict = ["file": pic?.jpegData(compressionQuality: 0.6) ?? Data()]
            
            //let josnDict = Utility.shared.json(from: ["siteCode": profile.siteCode ?? "", "amount": "\(txtFldEnterAmount.text ?? "")","staffCode": profile.staffCode ?? ""])
            let josnDict = Utility.shared.json(from: ["siteCode": selectedSite, "amount": "\(txtFldEnterAmount.text ?? "")","staffCode": profile.staffCode ?? ""])

            let params = ["jsonKey":josnDict ?? ""] as [String : AnyObject]
            
            let url = "\(base)\(Apis.getBankInAmount)"
            WebService.shared.uploadMediaToServer(api: url, imgMedia: imgdict , parameters: params) { (sucess, result, msg) in
                self.singleButtonAlertWith(title: "Bank In amount updated sucessfully" ,completionOnButton: {
                   self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}

extension BankInViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    //Picker View
    //PICKER VIEW DELEGATES AND DATASPURCES
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sitePicker {
            return profile.siteListing.count
       }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sitePicker {
            return profile.siteListing[row].siteCode ?? ""
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if pickerView == sitePicker {
            let model = profile.siteListing[row]
            selectedSite = model.siteCode
        }
        self.view.endEditing(true)
        getBankInDetail()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
