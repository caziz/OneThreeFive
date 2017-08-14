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
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

import UIKit

class LoadingIndicator: UIView {
    
    
    @IBOutlet weak var spinner: UIImageView!

    func startLoading(image: UIImage? = nil) {
        self.isHidden = false
        spinner.image = image
        spinner.layer.cornerRadius = 10
        spinner.clipsToBounds = true
        rotateView()
    }
    
    func stopLoading() {
        self.isHidden = true
        self.layer.removeAllAnimations()
    }
    
    private func rotateView(duration: Double = 0.75) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.spinner.transform = self.spinner.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            self.rotateView(duration: duration)
        }
    }
}
