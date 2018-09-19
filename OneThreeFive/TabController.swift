//
//  TabController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/7/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

extension UITabBar {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        isTranslucent = false
        shadowImage = UIImage()
        tintColor = UIColor.white
        barTintColor = Constants.UI.mainColor
    }
}
