//
//  ExpertProfilePageViewModel.swift
//  Briize
//
//  Created by Admin on 1/5/18.
//  Copyright © 2018 Miles Fishman. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public struct ExpertSettingCellModel {
    var image:UIImage?
    var settingName:String?
}

class ExpertProfilePageViewModel {
    
    let icons:[ExpertSettingCellModel] = [
        ExpertSettingCellModel(image:#imageLiteral(resourceName: "expertSettingAddIcon"), settingName: "Services"),
        ExpertSettingCellModel(image:#imageLiteral(resourceName: "expertSettingPaymentIcon"), settingName: "Payment"),
        ExpertSettingCellModel(image:#imageLiteral(resourceName: "expertSettingInstagramIcon"), settingName: "Instagram"),
        ExpertSettingCellModel(image:#imageLiteral(resourceName: "expertSettingHelpIcon"), settingName: "Support"),
        ExpertSettingCellModel(image:#imageLiteral(resourceName: "expertSettingCalendarIcon"), settingName: "Completed Orders"),
        ExpertSettingCellModel(image:#imageLiteral(resourceName: "expertSettingUndoIcon"), settingName: "Log-Out")
    ]
    let iconPhotos = Variable<[ExpertSettingCellModel]>([])
    
    init() {
        iconPhotos.value = icons
    }
    
    
}
