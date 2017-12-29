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
import RxCocoa
import RxSwift
import NVActivityIndicatorView

class SubCategorySelectionViewController: UIViewController, NVActivityIndicatorViewable {
    
    fileprivate var overlay             :UIView?
    fileprivate var chosenSubCategories :[String] = []
    fileprivate var viewModel           :SubCategorySelectionViewModel?
    fileprivate var count               :Int? = nil
    fileprivate var counter             :Int? = nil
    fileprivate var finalGroupOfExperts :[ExpertModel] = []
    
    var rxExpertArray = Variable<[ExpertModel]>([])
    let rxDisposebag  = DisposeBag()
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var suategoryCollectionView: UICollectionView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rxExpertArray.value.removeAll()
        SearchResultManager.shared.expertsToDisplay.removeAll()
        SearchResultManager.shared.subCatToSearchFor.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel = nil
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
    
    private func bindObservables() {
        self.rxExpertArray
            .asObservable()
            .subscribe(onNext: { [weak self] (modelArray) in
                guard let this = self else {return}
                
                guard modelArray.isEmpty == false else {
                    return DispatchQueue.main.async {
                        this.collapseLoading()
                    }
                }
                this.count     = this.counter
                let arrayCount = this.count
                
                switch modelArray.count == arrayCount {
                case true:
                    DispatchQueue.main.async {
                        this.collapseLoading()
                        
                        SearchResultManager
                            .shared
                            .expertsToDisplay = modelArray
                        
                        this.count   = 0
                        this.counter = 0
                        this.performSegue(withIdentifier: "showExpertSearch", sender: self)
                    }
                    
                case false:
                    return
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposebag)
    }
    
    private func convertExpertPicDataToImage(experts:[ExpertModel]) {
        self.counter = experts.count
        for e in experts {
            let file = e.profilePicFile!
            file.getDataInBackground(block: { (data, error) in
                if let data = data {
                    let image = UIImage(data:data)
                    
                    var expert = e
                    expert.profileImage = image
                    self.rxExpertArray.value.append(expert)
                }
            })
        }
    }
    
    private func setupLoading() {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = .black
        overlay!.alpha = 0.8
        view.addSubview(overlay!)
        
        let loaderSize = CGSize(width: 60.0, height: 60.0)
        startAnimating(loaderSize,
                       message: "Finding Experts...",
                       messageFont: nil,
                       type: .ballGridPulse,
                       color: kPinkColor,
                       padding: nil,
                       displayTimeThreshold: nil,
                       minimumDisplayTime: nil,
                       backgroundColor: nil,
                       textColor: .white)
    }
    
    func collapseLoading() {
        stopAnimating()
        overlay?.removeFromSuperview()
    }
    
    // MARK: Button Pressed Methods
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.setupLoading()
        
        let cats      = SearchResultManager.shared.subCatToSearchFor
        let chosenCat = SearchResultManager.shared.chosenCategory
        
        var viewM = self.viewModel
        viewM     = SubCategorySelectionViewModel(sender: self)
        
        let vm    = viewM!
        vm.findExperts(state        : "California",
                       category     : chosenCat,
                       subCategories: cats)
            .continueWith { [weak self] (experts) in
                guard let strongSelf = self else {return}
                
                switch experts.result != nil {
                case true:
                    guard let exps = experts.result else {return}
                    strongSelf.convertExpertPicDataToImage(experts: exps!)
                    
                case false:
                    if experts.error != nil {
                        //Handle Error
                    }
                }
        }
    }
    
}

extension SubCategorySelectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCollectionViewCell else {return}
        
        if  cell.layer.borderColor == kPinkColor.cgColor {
            return
        } else {
            SearchResultManager.shared.expertsToDisplay.removeAll()
            SearchResultManager.shared.subCatToSearchFor.append(cell.titleLabel.text!)
            
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = kPinkColor.cgColor
        }
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
