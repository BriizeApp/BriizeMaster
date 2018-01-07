//
//  CategorySelectViewModel.swift
//  Briize
//
//  Created by Admin on 1/2/18.
//  Copyright © 2018 Miles Fishman. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public struct MainCategory {
    var title:String = ""
    var image:UIImage?
}

class CategorySelectViewModel {
    
    let titles:[MainCategory] = [
        MainCategory(title: "Make-Up",image:#imageLiteral(resourceName: "cat2")),
        MainCategory(title: "Eyes & Brows",image:#imageLiteral(resourceName: "cat4")),
        MainCategory(title: "Hair",image:#imageLiteral(resourceName: "cat3")),
        MainCategory(title: "Nails",image:#imageLiteral(resourceName: "cat1"))
    ]
    let categories = Variable<[MainCategory]>([])
    
    init() {
        categories.value = titles
    }
    
}
