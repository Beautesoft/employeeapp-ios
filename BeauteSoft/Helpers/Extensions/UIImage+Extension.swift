//
//  UIImage+Extension.swift
//  App27
//
//  Created by Himanshu Singla on 07/02/19.
//  Copyright © 2019 INFOSIST Mobility Division. All rights reserved.
//

import UIKit
extension UIImage {
    func rotate(by degrees: CGFloat) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        
        // Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(origin: .zero, size: size))
        rotatedViewBox.transform = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, 0.0)
        
        guard let bitmap: CGContext = UIGraphicsGetCurrentContext(), let unwrappedCgImage: CGImage = cgImage else {
            return self
        }
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width/2.0, y: rotatedSize.height/2.0)
        
        // Rotate the image context
        bitmap.rotate(by: degreesToRadians(degrees))
        
        bitmap.scaleBy(x: CGFloat(1.0), y: -1.0)
        
        let rect: CGRect = CGRect(
            x: -size.width/2,
            y: -size.height/2,
            width: size.width,
            height: size.height)
        
        bitmap.draw(unwrappedCgImage, in: rect)
        
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        
        UIGraphicsEndImageContext()
        
        return newImage

    }
}
