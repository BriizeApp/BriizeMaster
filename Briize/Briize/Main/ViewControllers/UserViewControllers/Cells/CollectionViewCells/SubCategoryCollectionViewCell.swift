//
//  SubCategoryCollectionViewCell.swift
//  Briize
//
//  Created by Admin on 9/5/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import UIKit

class SubCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 12
    }
}
