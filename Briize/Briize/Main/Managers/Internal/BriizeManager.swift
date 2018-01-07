//
//  BriizeManager.swift
//  Briize
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class BriizeManager {
    
    private init(){}
    
    static var shared:BriizeManager = BriizeManager()
    
    var rxProfileImage       = Variable<UIImage?>(UserModel.current.profileImage)
    var rxLoadingData        = Variable<Bool>(false)
    var rxClientProfileState = Variable<String>("default")
    var rxExpertProfileState = Variable<String>("default")
    var rxExpertModelArray   = Variable<[ExpertModel]>([])
    
    var subCategoryArray          :[SubCategory] = []
    var categoryImage             :UIImage?
    var chosenCategoryTitle       :String = ""
    var currentSessionProfileState:String = ""
    
    func clean() {
        self.rxProfileImage       = Variable<UIImage?>(UserModel.current.profileImage)
        self.rxLoadingData        = Variable<Bool>(false)
        self.rxClientProfileState = Variable<String>("default")
        self.rxExpertProfileState = Variable<String>("default")
        self.rxExpertModelArray   = Variable<[ExpertModel]>([])
    }
    
    
    // Hard-Coded, should eventually fetch from database.
    func subCategoriesForCategory(category:String, img:UIImage) {
        self.chosenCategoryTitle = category
        self.categoryImage = img
        
        switch category {
        case "Nails":
            self.subCategoryArray = [SubCategory(title:"Manicure"), SubCategory(title:"Pedicure"), SubCategory(title:"Acrylic Fill"), SubCategory(title:"Design"), SubCategory(title:"Gel/Acrylic Removal")]
            
        case "Make-Up":
            self.subCategoryArray = [SubCategory(title:"Bridal"), SubCategory(title:"Costume"), SubCategory(title:"Airbrush"), SubCategory(title:"Evening"), SubCategory(title:"Glamorous")]
            
        case "Eyes & Brows":
            self.subCategoryArray = [SubCategory(title:"Threading"), SubCategory(title:"Waxing"), SubCategory(title:"Microblading"), SubCategory(title:"Eye Brow Tinting"), SubCategory(title:"Eye Lash Extensions"),SubCategory(title:"Eye Lash Lift")]
            
        case "Hair":
            self.subCategoryArray = [SubCategory(title:"Cut"), SubCategory(title:"Blowdry"), SubCategory(title:"Updue"), SubCategory(title:"Color"), SubCategory(title:"Braiding"),SubCategory(title:"Extensions")]
            
        default:
            print("Put alert view here since category doesn't exist")
        }
    }
    //
    
}
