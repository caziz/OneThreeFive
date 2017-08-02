//
//  LoadingIndicator.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/2/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

extension UIView {
    func spin(duration: CFTimeInterval = 0.75) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

import UIKit

class LoadingIndicator: UIImageView {
    
    func startLoading() {
        self.isHidden = false
        self.spin()

    }
    
    func stopLoading() {
        self.isHidden = true
        self.layer.removeAllAnimations()
    }
}
