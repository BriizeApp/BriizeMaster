//
//  SubCategorySelectionViewModel.swift
//  Briize
//
//  Created by Admin on 12/6/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import Parse
import BoltsSwift
import RxSwift
import RxCocoa
import NVActivityIndicatorView

public struct SubCategory {
    var title:String = "N/A"
}

class SubCategorySelectionViewModel {
    let titles = Variable<[SubCategory]>([])

    var expertsToUse:[ExpertModel] = []
    
    init() {
        let briizeManager     = BriizeManager.shared
        let subCategoryArray  = briizeManager.subCategoryArray
        self.titles.value     = subCategoryArray
    }
    
    func findExperts(state:String, category:String, subCategories:[String]) -> Task<[ExpertModel]?> {
        let completionTask = TaskCompletionSource<[ExpertModel]?>()
        
        let apiManager = APIManager()
        apiManager
            .findLiveExpertsInUserState(state        :state,
                                        category     : category,
                                        subCategories: subCategories)
            
            .continueWith(continuation: { names in
                switch names.error == nil {
                case true:
                    guard let experts = names.result else {return}
                    let user = UserModel.current
                    
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Finding Experts...30%")
                    
                    apiManager
                        .findExpertsClosestToUser(userLocation : user.currentLocation!,
                                                  experts      : experts!,
                                                  category     : category,
                                                  subCategories: subCategories)
                        
                        .continueWith(continuation: { expertArray in
                            switch expertArray.error == nil {
                            case true:
                                if expertArray.result != nil {
                                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Finding Experts...97%")
                                    
                                    apiManager
                                        .matchExpertsToChosenSubCategories(names        : expertArray.result!!,
                                                                           category     : category,
                                                                           subCategories: subCategories)
                                        
                                        .continueWith(continuation: { experts in
                                            switch experts.error == nil && experts.result != nil {
                                            case true:
                                                NVActivityIndicatorPresenter.sharedInstance.setMessage("Finding Experts...99%")
                                                
                                                completionTask.set(result: experts.result!)
                                                print("Did it")
                                                
                                            case false:
                                                print("error")
                                            }
                                        })
                                }
                                
                            case false:
                                print("error")
                            }
                        })
                    
                case false:
                    if let error = names.error {
                        print(error.localizedDescription)
                        //Handle Error
                    }
                }
            })
        return completionTask.task
    }
}
