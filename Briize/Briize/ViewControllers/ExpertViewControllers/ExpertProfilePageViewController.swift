//
//  File.swift
//  Briize
//
//  Created by Admin on 9/3/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ExpertProfilePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var expertNameLabel: UILabel!
    @IBOutlet weak var expertClientLabel: UILabel!
    @IBOutlet weak var expertRevenueLabel: UILabel!
    @IBOutlet weak var expertRatingLabel: UILabel!
    @IBOutlet weak var expertProfilePic: UIImageView!
    @IBOutlet weak var phPic1: UIImageView!
    @IBOutlet weak var phPic2: UIImageView!
    @IBOutlet weak var phPic3: UIImageView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    private func setupUI() {
        let expertModel = ExpertModel.shared
        
        self.navigationController?.navigationBar.isHidden = true
        
        guard let fullName = expertModel.fullName else {return}
        self.expertNameLabel.text    = fullName
        self.expertClientLabel.text  = "0"
        self.expertRevenueLabel.text = "$0.00"
        self.expertRatingLabel.text  = "5"
        
        self.expertProfilePic.layer.cornerRadius = 100
        self.expertProfilePic.layer.borderColor  = UIColor.white.cgColor
        self.expertProfilePic.layer.borderWidth  = 2
        
        //demoContent
        let picArray:[UIImageView] = [phPic1,phPic2,phPic3]
        self.picModifier(arrayOfImages: picArray)
    }
    
    func picModifier(arrayOfImages:[UIImageView]) {
        for i in arrayOfImages {
            i.layer.cornerRadius = 50
            i.layer.borderColor = UIColor.white.cgColor
            i.layer.borderWidth = 2
        }
    }
    @IBAction func exitButtonPressed(_ sender: Any) {
        
    }
    
}
