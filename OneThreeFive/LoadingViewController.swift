//
//  LoadingViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/7/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: LoadingIndicator!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.startLoading()
    }
    
}
