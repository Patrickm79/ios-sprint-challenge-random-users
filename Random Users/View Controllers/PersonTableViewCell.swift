//
//  PersonTableViewCell.swift
//  Random Users
//
//  Created by Patrick Millet on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    override func prepareForReuse() {
            super.prepareForReuse()
    }
    
    @IBOutlet weak var personThumbNail: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!

}
