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
    }
    func enable() {
        self.isHidden = false
        
    }
    
    func disable() {
        self.isHidden = true
    }
}
