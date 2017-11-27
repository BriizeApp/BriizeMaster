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

var tempPic:UIImage  = #imageLiteral(resourceName: "c")
var tempTitle:String = "title"

class SubCategorySelectionViewController: UIViewController {
    fileprivate let briizeManager = BriizeManager.shared
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var suategoryCollectionView: UICollectionView!
    @IBOutlet weak var mainPhoto: UIImageView!
    
    override func viewDidLoad() {
        self.setupUI()
    }
    
    private func setupUI() {
        self.suategoryCollectionView.delegate   = self
        self.suategoryCollectionView.dataSource = self
        
        guard let img = self.briizeManager.categoryImage else {return}
        let title = self.briizeManager.chosenCategoryTitle
        
        self.mainPhoto.image = img
        self.subTitle.text = title
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SubCategorySelectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchResultManager.shared.expertsToDisplay.removeAll()
        guard  let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCollectionViewCell else {return}
        SearchResultManager.shared.subCatToSearchFor = cell.titleLabel.text!
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cat = SearchResultManager.shared.subCatToSearchFor
        let chosenCat = SearchResultManager.shared.chosenCategory
        
        let query = PFQuery(className: chosenCat)
        query.whereKeyExists(cat)
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                print("Successfully retrieved \(objects!.count) sub Categories / \(chosenCat) : \(cat)")
                // The find succeeded.
                
                if let objects = objects {
                    for object in objects {
                        let name = object["expertName"] as! String
                        let price = object["\(SearchResultManager.shared.subCatToSearchFor)"] as! String
                        let model = ExpertModel(fullName: name, profileImage: nil, subCatPrice: price)
                       
                        SearchResultManager.shared.expertsToDisplay.append(model)
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showExpertSearch", sender: self)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        })
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.briizeManager.subCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCell", for: indexPath) as! SubCategoryCollectionViewCell
        cell.titleLabel.text = self.briizeManager.subCategoryArray[indexPath.row]
        
        return cell
    }
    
}
