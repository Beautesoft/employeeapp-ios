//
//  TaskAcceptVC.swift
//  BeauteSoft
//
//  Created by Ankit pahwa on 10/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import UIKit
protocol TaskAcceptedDelegate: class {
    func didAcceptTask()
}
class TaskAcceptVC: UIViewController {

    @IBOutlet weak var btnSelectFile: UIButton!
    @IBOutlet weak var txtVwQuries: UITextView!
    @IBOutlet weak var txtVwRemark: UITextView!
    weak var delegate: TaskAcceptedDelegate?
    let imagePicker = UIImagePickerController()
    var imageData:Data?
    var taskId: String?
    var pic:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: Butotn action
    @IBAction func actionSelectFiles(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        initiateImagePicker(imagePicker, isVideo: false, editingAllowed: true)
    }
    @IBAction func actionSubmit(_ sender: Any) {
         if txtVwRemark.text == "Remark" || txtVwRemark.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.singleButtonAlertWith(message: .custom("Please add some remark"), button: .ok)
         }else {
            self.acceptedTask ()
        }
    }
    private func acceptedTask () {
        let url = "\(base)\(Apis.updateTaskStatus)"
        let parameter = [
            "taskID": taskId ?? "",
            "status": 1,
            "siteCode": profile.siteCode ?? "",
            "remarks": txtVwRemark.text.trimmingCharacters(in: .whitespaces),
            "queries": txtVwQuries.text.trimmingCharacters(in: .whitespaces)
            ] as [String: AnyObject]
        
        WebService.shared.postDataFor(api: url, parameters: parameter as [String : AnyObject]) { (sucess, response, msg) in
            if self.pic != nil{
                self.updateTaskPicture()
            }else{
                self.goBack ()
            }
        }
    }
    func updateTaskPicture(){
        if pic != nil{
            //{"siteCode":"HS04","taskID":"25","userID":""}
            let imgdict = ["file": pic.jpegData(compressionQuality: 0.6) ?? Data()]
            let josnDict = Utility.shared.json(from: ["siteCode": profile.siteCode ?? "" , "userID": profile.userID ?? "","taskID": taskId ?? ""])
            let params = ["jsonKey":josnDict ?? ""] as [String : AnyObject]
            let url = "\(base)\(Apis.updateTaskPicture)"
            WebService.shared.uploadMediaToServer(api: url, imgMedia: imgdict , parameters: params) { (sucess, result, msg) in
                self.goBack ()
            }
        }
    }
    private func goBack () {
        delegate?.didAcceptTask()
        self.dismiss(animated: true, completion: nil)
    }
}
extension TaskAcceptVC: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView == txtVwRemark {
//
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtVwRemark{
            if textView.text == "Remark"{
                textView.text = ""
                textView.textColor = UIColor.darkText
            }
        }else if textView == txtVwQuries{
            if textView.text == "Add Queries"{
                textView.text = ""
                textView.textColor = UIColor.darkText
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtVwRemark{
            if textView.text == "" {
                textView.text = "Remark"
                textView.textColor = UIColor.lightGray
            }
        }else if textView == txtVwQuries{
            if textView.text == "" {
                textView.text = "Add Queries"
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
extension TaskAcceptVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- Methods to upload image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        picker.allowsEditing = true
        if let pickedImage = info[.originalImage] as? UIImage {
            pic = pickedImage
            picker.allowsEditing = true
            picker.delegate = self
            btnSelectFile.setTitle("1 image selected", for: .normal)
            imageData = pickedImage.jpegData(compressionQuality: 0.6) ?? Data()
        }
        //dismiss(animated: true, completion: nil)
    }
    func imagePicker(_ imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
