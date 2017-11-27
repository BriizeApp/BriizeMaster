//
//  ExpertModel.swift
//  Briize
//
//  Created by Admin on 10/24/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

struct ExpertModel {
    
    static var shared:ExpertModel = ExpertModel()
    
    var fullName: String?
    var profileImage: UIImage?
    
    //For Search Results to User Only!
    var subCatPrice: String = ""
}
