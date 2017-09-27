//
//  File.swift
//  Briize
//
//  Created by Admin on 9/3/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

class ExpertProfilePageViewController :  UIViewController {
    
    @IBOutlet weak var expertProfilePic: UIImageView!
    
    @IBOutlet weak var phPic1: UIImageView!
    @IBOutlet weak var phPic2: UIImageView!
    @IBOutlet weak var phPic3: UIImageView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let picArray:[UIImageView] = [phPic1,phPic2,phPic3]
        self.picModifier(arrayOfImages: picArray)
        
        self.expertProfilePic.layer.cornerRadius = 100
        self.expertProfilePic.layer.borderColor = UIColor.white.cgColor
        self.expertProfilePic.layer.borderWidth = 2
    }
    
    func picModifier(arrayOfImages:[UIImageView]) {
        for i in arrayOfImages {
            i.layer.cornerRadius = 50
            i.layer.borderColor = UIColor.white.cgColor
            i.layer.borderWidth = 2
        }
    }
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
