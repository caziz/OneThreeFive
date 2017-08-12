//
//  ErrorMessage.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/10/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ErrorMessage: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //isHidden = true
    }
    func enable(bottom: UILayoutSupport, axis: CGFloat, size: CGFloat) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "down"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint(item: imageView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: superview!,
                           attribute: .centerX,
                           multiplier: 1.75,
                           constant: 0).isActive = true
        let constraint = imageView.topAnchor.constraint(equalTo: bottomAnchor)
        constraint.isActive = true
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.superview?.layoutIfNeeded()

        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            constraint.isActive = false
            imageView.bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
            self.superview?.layoutIfNeeded()
        }, completion: { completed in
            imageView.removeFromSuperview()
        })
    }
    
    func disable() {
        self.isHidden = true
    }
}
