//
//  SubCategorySelectionViewController.swift
//  Briize
//
//  Created by Admin on 9/5/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SubCategorySelectionViewController: UIViewController {
    
    fileprivate var chosenSubCategories:[String] = []
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var suategoryCollectionView: UICollectionView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SearchResultManager.shared.expertsToDisplay.removeAll()
        SearchResultManager.shared.subCatToSearchFor.removeAll()
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    private func setupUI() {
        let briizeManager = BriizeManager.shared
        guard let img = briizeManager.categoryImage else {return}
        let title = briizeManager.chosenCategoryTitle
        
        self.suategoryCollectionView.delegate   = self
        self.suategoryCollectionView.dataSource = self
        
        self.submitButtonOutlet.layer.cornerRadius = 12
        self.mainPhoto.image = img
        self.subTitle.text = title
    }
    
    // MARK: Button Pressed Methods
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let cats = SearchResultManager.shared.subCatToSearchFor
        let chosenCat = SearchResultManager.shared.chosenCategory
        
        if cats.count >= 0 {
            let query = PFQuery(className: chosenCat)
            query.findObjectsInBackground(block: { (objects, error) in
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
                                    continue
                                }
                            }
                            if objToUse != nil {
                                let name = objToUse!["expertName"] as! String
                                model = ExpertModel(fullName: name, profileImage: nil, subCatPrice: totalPrice)
                                SearchResultManager.shared.expertsToDisplay.append(model!)
                            }
                        }
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showExpertSearch", sender: self)
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.localizedDescription)")
                }
            })
        } else {
            print("No Sub Categories Selected")
        }
    }
    
}

extension SubCategorySelectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCollectionViewCell else {return}
        SearchResultManager.shared.expertsToDisplay.removeAll()
        SearchResultManager.shared.subCatToSearchFor.append(cell.titleLabel.text!)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let briizeManager = BriizeManager.shared
        return briizeManager.subCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let briizeManager = BriizeManager.shared
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCell", for: indexPath) as! SubCategoryCollectionViewCell
        cell.titleLabel.text = briizeManager.subCategoryArray[indexPath.row]
        
        return cell
    }
    
}
