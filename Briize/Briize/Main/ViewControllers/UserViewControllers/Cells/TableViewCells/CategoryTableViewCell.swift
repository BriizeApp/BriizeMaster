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

    var category: MainCategory? {
        didSet {
            guard let title = category else { return }
            catTitle.text = title.title
            catImage.image = title.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
