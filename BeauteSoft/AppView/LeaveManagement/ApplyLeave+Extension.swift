//
//  ApplyLeave+Extension.swift
//  BeauteSoft
//
//  Created by Ankit Pahwa on 06/06/19.
//  Copyright © 2019 Himanshu Singla. All rights reserved.
//

import Foundation
import UIKit
extension ApplyLeaveVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- Methods to upload image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        picker.allowsEditing = true
        if let pickedImage = info[.originalImage] as? UIImage {
            pic = pickedImage
            imgView.contentMode = .scaleToFill
            imgView.image = pickedImage
            picker.allowsEditing = true
            self.isSelectedImage = true
            picker.delegate = self
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
