//
//  ProfileVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/4/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit
import SDWebImage
class ProfileVC: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var btnStaffCode: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var statusTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    let imagePicker = UIImagePickerController()
  
    var pic:UIImage?
    private let loginBL = LoginBL()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValueOnScreen()
        // Do any additional setup after loading the view.
    }
    //MARK:- Methods to upload image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        picker.allowsEditing = true
        if let pickedImage = info[.originalImage] as? UIImage {
            
            picker.allowsEditing = true
            picker.delegate = self
            self.profileImgView.contentMode = .scaleToFill
            self.profileImgView.image = pickedImage
            pic = self.profileImgView.image
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePicker(_ imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Button Action
    @IBAction func updateProfileBtntap(_ sender: Any) {
        updateProfile()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadImgBtntap(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        initiateImagePicker(imagePicker, isVideo: false, editingAllowed: true)
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Set the initial value to the view
    private func setValueOnScreen(){
        lblDisplayName.text = profile.name ?? ""
        firstNameTF.text = profile.firstName ?? ""
        lastNameTF.text = profile.lastName ?? ""
        if let role = profile.role{
            if role == .staff{
                statusTF.text = "Staff"
            }else{
                statusTF.text = "Manager"
            }
        }
        locationTF.text = profile.location ?? ""
        phoneNumTF.text = profile.contact ?? ""
        btnStaffCode.setTitle(profile.staffCode ?? "", for: .normal)
        
        if  let profilePic = profile.profilePic {
            Indicator.shared.show()
                self.profileImgView.sd_setImage(with: URL(string: profilePic) , placeholderImage: UIImage(named: "profile"))
            self.profileImgView.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(named: "profile"), options: .refreshCached) { (image, error, cacheType, url) in
                Indicator.shared.hide()
            }
        }
    }
   
    private func updateProfile(){
        let params = ["userID": profile.userID ?? "","firstName": firstNameTF.trimmedText,"lastName": lastNameTF.trimmedText,"title": statusTF.trimmedText,"contactNo": phoneNumTF.trimmedText,"siteCode": profile.siteCode,"address": locationTF.trimmedText,"staffCode": profile.staffCode] as [String : AnyObject]
        let jsonDict = ["jsonKey": Utility.shared.json(from: params)] as [String : AnyObject]
        WebService.shared.uploadMediaToServer(api: base + Apis.updateProfile, imgMedia: nil , parameters: jsonDict) { (sucess, result, msg) in
            if self.pic == nil {
                self.login()
            } else {
                DispatchQueue.main.async {
                    self.updateProfilepicture()
                }
            }
            
        }
    }
    private func updateProfilepicture() {
        let imgdict = ["file": profileImgView.image?.jpegData(compressionQuality: 0.6) ?? Data()]
        let josnDict = Utility.shared.json(from: ["siteCode": profile.siteCode ?? "" , "staffCode": profile.staffCode ?? ""])
        let params = ["jsonKey":josnDict ?? ""] as [String : AnyObject]
        
        WebService.shared.uploadMediaToServer(api: base + Apis.updateProfilePicture, imgMedia: imgdict , parameters: params) { (sucess, result, msg) in
           self.login()
        }
    }
    func login() {
        let params = ["userID": UserDefaultsManager.userId ?? "",
                      "email": UserDefaultsManager.userId ?? "",
                      "password": UserDefaultsManager.password ?? "",
                      "companyCode": UserDefaultsManager.locale ?? ""] as [String : Any]
        loginBL.login(params: params) {
            self.setValueOnScreen()
            self.singleButtonAlertWith( message: .profileUpdated, completionOnButton: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }
    }

}
