//
//  SearchResultManager.swift
//  Briize
//
//  Created by Brianna Cuba on 11/26/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation

public class SearchResultManager {
    
    static var shared:SearchResultManager = SearchResultManager()
    
    var chosenCategory: String = ""
    var subCatToSearchFor: [String] = []
    var expertsToDisplay: [ExpertModel] = []
}
