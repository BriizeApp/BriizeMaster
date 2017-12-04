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

// MARK: Reactive Constants
public var kRxMenuImage   = Variable<UIImage?>(UserModel.shared.profileImage)
public var kRxLoadingData = Variable<Bool>(false)

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
