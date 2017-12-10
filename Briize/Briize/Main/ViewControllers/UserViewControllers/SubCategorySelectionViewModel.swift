//
//  SubCategorySelectionViewModel.swift
//  Briize
//
//  Created by Admin on 12/6/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import Parse

class SubCategorySelectionViewModel {
    var bindedController:SubCategorySelectionViewController
    var expertsToUse:[ExpertModel] = []
    
    init(sender:SubCategorySelectionViewController) {
        self.bindedController = sender
    }
    
    func findExperts(category:String, subCategories:[String]) -> [ExpertModel]? {
        let cats = subCategories
        let chosenCat = category
        
        if cats.count >= 0 {
            let query = PFQuery(className: chosenCat)
            query.findObjectsInBackground(block: { [weak self] (objects, error) in
                guard let strongSelf = self else {return}
                
                if error == nil {
                    print("Successfully retrieved")
                    if let objects = objects {
                        var totalPrice:Int = 0
           
                        for object in objects {
                            var model:ExpertModel?
                            var objToUse:PFObject?
                            
                            for c in cats {
                                let price = object[c] as? Int ?? 0
                                if price != 0 {
                                    totalPrice += price
                                    objToUse = object
                                } else {
                                    objToUse = nil
                                }
                            }
                            if objToUse != nil {
                                var experts:[ExpertModel] = []
                                let name = objToUse!["expertName"] as! String
                                model = ExpertModel(fullName: name, profileImage: nil, subCatPrice: totalPrice)
                                experts.append(model!)
                            }
                        }
                        DispatchQueue.main.async {
                            strongSelf.bindedController.performSegue(withIdentifier: "showExpertSearch", sender: self)
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.localizedDescription)")
                }
            })
        } else {
            print("No Sub Categories Selected")
        }
        return nil
    }
    
}
