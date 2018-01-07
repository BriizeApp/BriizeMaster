//
//  ExpertSettingCollectionViewCell.swift
//  Briize
//
//  Created by Admin on 1/5/18.
//  Copyright © 2018 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

class ExpertSettingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var settingIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var icon: ExpertSettingCellModel? {
        didSet {
            guard let icon = icon else { return }
            settingIcon.image = icon.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.0
        self.layer.borderColor = kPinkColor.cgColor
    }
}
