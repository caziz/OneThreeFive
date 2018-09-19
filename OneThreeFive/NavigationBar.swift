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
        tintColor = UIColor.white
        barTintColor = Constants.UI.mainColor
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        backItem?.backBarButtonItem = backButton
        titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Avenir-Black", size: 30)!]
    }
    
    
}

extension UIBarButtonItem {
    override open func awakeFromNib() {
        super.awakeFromNib()
        tintColor = UIColor.white
    }
}
