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
    var fullName:String?
    var profileImage: UIImage?
    
    static var shared:ExpertModel = ExpertModel()
    
}
