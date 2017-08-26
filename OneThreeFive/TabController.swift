//
//  TabController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/7/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

extension UITabBar {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        isTranslucent = false
        shadowImage = UIImage()
        tintColor = Constants.UI.mainColor
        
        let border = CALayer()
        border.backgroundColor = Constants.UI.borderColor.cgColor
        border.frame = CGRect(x: 0, y: frame.minY, width: frame.size.width * 10, height: Constants.UI.borderWidth)
        layer.addSublayer(border)
    }
}
