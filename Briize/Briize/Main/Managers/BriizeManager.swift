//
//  BriizeManager.swift
//  Briize
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

public class BriizeManager {
    
    static var shared:BriizeManager = BriizeManager()
    
    var subCategoryArray:[String] = []
    var categoryImage:UIImage?
    var chosenCategoryTitle:String = ""
    
    func subCategoriesForCategory(category:String, img:UIImage) {
        self.chosenCategoryTitle = category
        self.categoryImage = img
        
        switch category {
        case "Nails":
            self.subCategoryArray = ["Manicure", "Pedicure", "Acrylic Fill", "Acrylic Full", "Design", "Gel/Acrylic Removal"]
            
        case "Make-Up":
            self.subCategoryArray = ["Bridal", "Custume", "Airbrush", "Evening", "Glamorous"]
            
        case "Eyes & Brows":
            self.subCategoryArray = ["Threading", "Waxing", "Microblading", "Eye Brow Tinting", "Eye Lash Extensions", "Eye Lash Lift"]
  
        case "Hair":
            self.subCategoryArray = ["cut", "Blowdry", "Updue", "color", "Braiding", "Extensions"]
            
        default:
            print("Put alert view here since category doesn't exist")
        }
    }
    
}
