//  UIViewController+Extension.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import UIKit

extension UIViewController {
    private func openCamera(_ imagePicker: UIImagePickerController, isVideoAllowed: Bool, editingAllowed: Bool) {
        DispatchQueue.main.async {
            if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                if isVideoAllowed {
                    imagePicker.mediaTypes =  ["public.image", "public.movie"]
                    imagePicker.videoMaximumDuration = 15
                }
                imagePicker.allowsEditing = editingAllowed
                self .present(imagePicker, animated: true, completion: nil)
            }  else {
                self.singleButtonAlertWith(message: .cameraSupport, button: .ok)
            }
        }
    }
    
    private func openGallery(_ imagePicker: UIImagePickerController, isVideo: Bool) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        if isVideo {
            imagePicker.mediaTypes =  ["public.image", "public.movie"]
            imagePicker.videoMaximumDuration = 15
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func initiateImagePicker(_ imagePicker: UIImagePickerController, isVideo: Bool = false, editingAllowed: Bool = false) {
        let alert = UIAlertController(title: Messages.chooseOption.value, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: Messages.camera.value, style: .default) {
            UIAlertAction in
            self.openCamera(imagePicker, isVideoAllowed: isVideo, editingAllowed: editingAllowed)
        }
        let gallaryAction = UIAlertAction(title: Messages.photos.value, style: .default) {
            UIAlertAction in
            self.openGallery(imagePicker, isVideo: isVideo)
        }
        let cancelAction = UIAlertAction(title: Messages.cancel.value, style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessage(titleStr:String, messageStr:String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
           
            
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
            
        default:
            if let presentedViewController = vc.presentedViewController {
                //print(presentedViewController)
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc;
                }
            }
            else{
                return vc;
            }
            
        }
        
    }
    
}

