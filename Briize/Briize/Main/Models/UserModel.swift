//
//  UserModel.swift
//  Briize
//
//  Created by Admin on 10/24/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

public struct UserModel {
    
    static var current:UserModel = UserModel()
    
    var fullName:String?
    var profileImage:UIImage?
    var currentLocation:PFGeoPoint?
}
