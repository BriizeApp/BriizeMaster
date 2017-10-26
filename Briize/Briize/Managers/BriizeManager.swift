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
            self.subCategoryArray = ["Manicure", "Pedicure", "French", "Nail Art", "Fill In", "Gel"]
            
        case "Make-Up":
            self.subCategoryArray = ["Bridal", "Custume", "Airbrush", "Evening", "Glamorous", "Custom"]
            
        case "Eyes & Brows":
            self.subCategoryArray = ["Threading", "Extensions", "Eyebrow", "Tinting", "Eye Make-Up", "Custom"]
  
        case "Hair":
            self.subCategoryArray = ["Cut", "Blowdry", "Updue", "Color", "Braiding", "Custom"]
            
        default:
            print("Put alert view here since category doesn't exist")
        }
    }
    
}
