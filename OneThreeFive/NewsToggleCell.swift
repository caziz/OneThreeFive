//
//  NewsToggleCell.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

protocol NewsToggleCellDelegate: class {
    func didToggleNewsSource(on cell: NewsToggleCell)
}

class NewsToggleCell: UITableViewCell {
    weak var delegate: NewsToggleCellDelegate?
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var toggle: UISwitch!    
    @IBAction func switchToggled(_ sender: UISwitch) {
        toggleNewsSource()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleNewsSource))
        addGestureRecognizer(tap)
        toggle.onTintColor = Constants.UI.blue
    }
    func toggleNewsSource() {
        delegate?.didToggleNewsSource(on: self)
    }
}


