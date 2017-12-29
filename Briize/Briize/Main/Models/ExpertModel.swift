//
//  ExpertModel.swift
//  Briize
//
//  Created by Admin on 10/24/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

public struct ExpertModel {
    
    static var current:ExpertModel = ExpertModel()
    
    var fullName: String?
    var profileImage: UIImage?
    var profilePicFile: PFFile?
    var currentLocation: PFGeoPoint?
    
    //For Search Results Only
    var subCatPrice: Int = 0
}
