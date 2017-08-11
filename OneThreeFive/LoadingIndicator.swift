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
    var background: LoadingIndicatorBackground?
    func startLoading() {
        self.isHidden = false
        self.spin()
        background?.layer.cornerRadius = 10
        background?.clipsToBounds = true
        background?.isHidden = false

    }
    
    func stopLoading() {
        self.isHidden = true
        self.layer.removeAllAnimations()
        background?.isHidden = true
    }
}

class LoadingIndicatorBackground: UIImageView {}
