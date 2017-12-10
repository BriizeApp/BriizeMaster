//
//  Constants.swift
//  Briize
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/// *** Public Constants *** ///

// MARK: UI Contants
public var kPinkColor = UIColor(red: 255.0/255.0, green: 195.0/255.0, blue: 225.0/255.0, alpha: 1.0)

// MARK: Public Reactive Observables
public var kRxMenuImage          = Variable<UIImage?>(UserModel.current.profileImage)
public var kRxLoadingData        = Variable<Bool>(false)
public var kRxUserProfileState   = Variable<String>("default")
public var kRxExpertProfileState = Variable<String>("default")

public var kUSStates:[String] = [ "Alabama",
                                  "Alaska",
                                  "American Samoa",
                                  "Arizona",
                                  "Arkansas",
                                  "California",
                                  "Colorado",
                                  "Connecticut",
                                  "Delaware",
                                  "District Of Columbia",
                                  "Federated States Of Micronesia",
                                  "Florida",
                                  "Georgia",
                                  "Guam",
                                  "Hawaii",
                                  "Idaho",
                                  "Illinois",
                                  "Indiana",
                                  "Iowa",
                                  "Kansas",
                                  "Kentucky",
                                  "Louisiana",
                                  "Maine",
                                  "Marshall Islands",
                                  "Maryland",
                                  "Massachusetts",
                                  "Michigan",
                                  "Minnesota",
                                  "Mississippi",
                                  "Missouri",
                                  "Montana",
                                  "Nebraska",
                                  "Nevada",
                                  "New Hampshire",
                                  "New Jersey",
                                  "New Mexico",
                                  "New York",
                                  "North Carolina",
                                  "North Dakota",
                                  "Northern Mariana Islands",
                                  "Ohio",
                                  "Oklahoma",
                                  "Oregon",
                                  "Palau",
                                  "Pennsylvania",
                                  "Puerto Rico",
                                  "Rhode Island",
                                  "South Carolina",
                                  "South Dakota",
                                  "Tennessee",
                                  "Texas",
                                  "Utah",
                                  "Vermont",
                                  "Virgin Islands",
                                  "Virginia",
                                  "Washington",
                                  "West Virginia",
                                  "Wisconsin",
                                  "Wyoming"]

// MARK: Public Extensions
public extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
