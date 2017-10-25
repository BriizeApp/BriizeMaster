//
//  SubCategorySelectionViewController.swift
//  Briize
//
//  Created by Admin on 9/5/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

var tempPic:UIImage  = #imageLiteral(resourceName: "c")
var tempTitle:String = "title"

class SubCategorySelectionViewController: UIViewController {
    var testArray:[String] = ["Cut","Blowdry","Updue", "Color", "Braiding","Custom"]
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var suategoryCollectionView: UICollectionView!
    @IBOutlet weak var mainPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        
        self.mainPhoto.image = tempPic
        self.suategoryCollectionView.delegate   = self
        self.suategoryCollectionView.dataSource = self
        self.subTitle.text = tempTitle
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
       print("ha")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCell", for: indexPath) as! SubCategoryCollectionViewCell
        
        cell.titleLabel.text = self.testArray[indexPath.row]
        
        return cell
    }
    
}
