//
//  FavoritedArticleCell.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/18/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class FavoritedArticleCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.layer.cornerRadius = 3
    }
}
