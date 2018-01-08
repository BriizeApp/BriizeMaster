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
    fileprivate var count               :Int? = nil
    fileprivate var counter             :Int? = nil
    fileprivate var finalGroupOfExperts :[ExpertModel] = []
    
    var rxExpertArray = Variable<[ExpertModel]>([])
    let rxDisposebag  = DisposeBag()
    let viewModel     = SubCategorySelectionViewModel()
    
    @IBOutlet weak var collecTionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var suategoryCollectionView: UICollectionView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindObservables()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rxExpertArray.value.removeAll()
        print("appeared")
        SearchResultManager.shared.expertsToDisplay.removeAll()
        SearchResultManager.shared.subCatToSearchFor.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initialLoadAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("gone")
        let cells = self.suategoryCollectionView.visibleCells
        for cell in cells {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    private func setupUI() {
        let briizeManager = BriizeManager.shared
        guard let img = briizeManager.categoryImage else {return}
        let title = briizeManager.chosenCategoryTitle
        
        self.mainPhoto.image = img
        self.subTitle.text = title
        
        self.submitButtonOutlet.backgroundColor    = .white
        self.submitButtonOutlet.layer.cornerRadius = 8
        self.submitButtonOutlet.layer.borderWidth  = 2.0
        self.submitButtonOutlet.layer.borderColor  = kGoldColor.cgColor
        self.submitButtonOutlet.setTitleColor(kGoldColor, for: .normal)
    }
    
    private func initialLoadAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: .curveEaseInOut,
                       animations: {
                        self.collecTionViewHeightConstraint.constant = 275
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    private func configureCollectionView() {
        self.collecTionViewHeightConstraint.constant    = 350
        
        self.suategoryCollectionView.layer.cornerRadius = 18
        self.suategoryCollectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard  let cell = self?.suategoryCollectionView.cellForItem(at: indexPath) as? SubCategoryCollectionViewCell else {return}
                
                if  cell.layer.borderColor == kPinkColor.cgColor {
                    cell.layer.borderColor = UIColor.clear.cgColor
                    
                    let myArray = SearchResultManager.shared.subCatToSearchFor
                    SearchResultManager.shared.subCatToSearchFor = myArray.filter{
                        $0 != cell.titleLabel.text!
                    }
                    return
                    
                } else {
                    cell.layer.borderWidth = 4.0
                    cell.layer.borderColor = kPinkColor.cgColor
                    
                    SearchResultManager.shared.subCatToSearchFor.append(cell.titleLabel.text!)
                }
                self?.suategoryCollectionView.deselectItem(at: indexPath, animated: true)
            })
            .disposed(by: self.rxDisposebag)
    }
    
    private func bindObservables() {
        self.viewModel
            .titles
            .asObservable()
            .bind(to: self.suategoryCollectionView.rx.items(
                cellIdentifier: "subCategoryCell",
                cellType: SubCategoryCollectionViewCell.self)
            ) {
                row, subCategory, cell in
                cell.subCategory = subCategory
            }
            .disposed(by: self.rxDisposebag)
        
        kRxExpertArray
            .asObservable()
            .subscribe(onNext: { [weak self] (modelArray) in
                guard let this = self else {return}
                
                if modelArray.isEmpty == false {
                    this.count     = this.counter
                    let arrayCount = this.count
                    
                    switch modelArray.count == arrayCount {
                    case true:
                        DispatchQueue.main.async {
                            SearchResultManager.shared.expertsToDisplay = modelArray
                            
                            this.collapseLoading()
                            this.count   = 0
                            this.counter = 0
                            this.performSegue(withIdentifier: "showExpertSearch", sender: self)
                        }
                        
                    case false:
                        return
                    }
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
                    kRxExpertArray.value.append(expert)
                }
            })
        }
    }
    
    private func submitSubCategoriesAndFindExpert() {
        let cats      = SearchResultManager.shared.subCatToSearchFor
        let chosenCat = SearchResultManager.shared.chosenCategory
        
        self.viewModel
            .findExperts(state        : "California",
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
    
    private func collapseLoading() {
        stopAnimating()
        overlay?.removeFromSuperview()
    }
    
    // MARK: Button Pressed Methods
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.setupLoading()
        self.submitSubCategoriesAndFindExpert()
    }
    
}

