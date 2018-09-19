//
//  UIImageExtension.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 9/18/18.
//  Copyright © 2018 Christopher Aziz. All rights reserved.
//
import UIKit

extension UIImage {
    func scaleToSize(_ size: CGSize) -> UIImage? {
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        let image = self
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
