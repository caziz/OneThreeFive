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
        layer.borderWidth = Constants.UI.borderWidth
        layer.borderColor = Constants.UI.borderColor.cgColor
        clipsToBounds = true
    }
}
