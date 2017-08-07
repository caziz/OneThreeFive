//
//  NavigationBar.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/4/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // remove default nav bar color and border
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        isTranslucent = false
        shadowImage = UIImage()
        
        
        

        
        // add border to main view controller nav bar
        if self.tag == 1 {
            let border = CALayer()
            border.backgroundColor = Constants.UI.borderColor.cgColor
            border.frame = CGRect(x: 0, y: frame.size.height - Constants.UI.borderWidth, width: frame.size.width * 2, height: Constants.UI.borderWidth)
            layer.addSublayer(border)
        }
    }
}
