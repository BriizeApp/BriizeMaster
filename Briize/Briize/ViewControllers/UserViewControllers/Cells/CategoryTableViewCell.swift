//
//  CategoryTableViewCell.swift
//  Briize
//
//  Created by Admin on 8/15/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
