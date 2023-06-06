//
//  UpdateEmployee+Extension.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 21/05/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
import UIKit
extension UpdateEmployeeVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- Methods to upload image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        picker.allowsEditing = true
        if let pickedImage = info[.originalImage] as? UIImage {
            picker.allowsEditing = true
            picker.delegate = self
            imgEmployee.contentMode = .scaleToFill
            imageData = pickedImage.jpegData(compressionQuality: 0.6) ?? Data()
            imgEmployee.image = pickedImage
            pic = imgEmployee.image
            isEmpImageSelected = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePicker(_ imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
