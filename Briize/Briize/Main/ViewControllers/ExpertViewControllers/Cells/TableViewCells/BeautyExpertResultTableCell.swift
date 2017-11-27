//
//  BeautyExpertResultTableCell.swift
//  Briize
//
//  Created by Admin on 8/15/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import UIKit

class BeautyExpertResultTableCell: UITableViewCell {

    
    @IBOutlet weak var expertImage: UIImageView!
    @IBOutlet weak var expertName: UILabel!
    @IBOutlet weak var expertSpecialty: UILabel!
    @IBOutlet weak var expertDistance: UILabel!
    @IBOutlet weak var requestButtonOutlet: UIButton!
    @IBOutlet weak var schedRequestButtonOutlet: UIButton!
    @IBOutlet weak var photosButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        requestButtonOutlet.layer.cornerRadius = 8
        schedRequestButtonOutlet.layer.cornerRadius = 8
        photosButtonOutlet.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
