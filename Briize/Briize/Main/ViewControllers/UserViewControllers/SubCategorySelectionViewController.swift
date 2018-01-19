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
    fileprivate var count               :Int? = 0
    fileprivate var counter             :Int? = 0
    fileprivate var finalGroupOfExperts :[ExpertModel] = []
    
    private let rxDisposebag  = DisposeBag()
    private let viewModel     = SubCategorySelectionViewModel()
    
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
        self.refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initialLoadAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cleanUp()
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
        
        BriizeManager
            .shared
            .rxExpertModelArray
            .asObservable()
            .subscribe(onNext: { [weak self] (modelArray) in
                guard let this = self else {return}
                
                if modelArray.isEmpty == false {
                    this.prepareDataWithExpertModelArray(modelArray: modelArray)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposebag)
    }
    
    private func prepareDataWithExpertModelArray(modelArray:[ExpertModel]) {
        self.count     = self.counter
        let arrayCount = self.count
        
        print(arrayCount!, modelArray.count)
        
        switch modelArray.count == arrayCount {
        case true:
            SearchResultManager.shared.expertsToDisplay = modelArray
            print("im hererererere")
            
            DispatchQueue.main.async {
                self.collapseLoading()
                self.count   = 0
                self.counter = 0
                
                self.performSegue(withIdentifier: "showExpertSearch", sender: self)
            }
            
        case false:
            print("im ahhhhhhh")
            self.collapseLoading()
            
            break
        }
    }
    
    private func configureCollectionView() {
        self.collecTionViewHeightConstraint.constant    = 350
        self.suategoryCollectionView.layer.cornerRadius = 18
        
        self.suategoryCollectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard  let cell = self?.suategoryCollectionView.cellForItem(at: indexPath) as? SubCategoryCollectionViewCell else {return}
                
                self?.configureSelectedCellData(cell)
                self?.suategoryCollectionView.deselectItem(at: indexPath, animated: true)
            })
            .disposed(by: self.rxDisposebag)
    }
    
    private func configureSelectedCellData(_ cell: SubCategoryCollectionViewCell) {
        if  cell.layer.borderColor == kPinkColor.cgColor {
            cell.layer.borderColor = UIColor.clear.cgColor
            
            let myArray = SearchResultManager.shared.subCatToSearchFor
            SearchResultManager.shared.subCatToSearchFor = myArray.filter {
                $0 != cell.titleLabel.text!
            }
            return
            
        } else {
            cell.layer.borderWidth = 4.0
            cell.layer.borderColor = kPinkColor.cgColor
            
            SearchResultManager.shared.subCatToSearchFor.append(cell.titleLabel.text!)
        }
    }
    
    private func convertExpertPicDataToImage(experts:[ExpertModel]) {
        self.counter = experts.count
        print(self.counter!)
        
        for e in experts {
            let file = e.profilePicFile!
            file.getDataInBackground(block: { (data, error) in
                if let data = data {
                    let image = UIImage(data:data)
                    
                    var expert = e
                    expert.profileImage = image
                    
                    BriizeManager.shared.rxExpertModelArray.value.append(expert)
                }
            })
        }
    }
    
    private func submitSubCategoriesAndFindExpert() {
        let cats      = SearchResultManager.shared.subCatToSearchFor
        let chosenCat = SearchResultManager.shared.chosenCategory
        
        if cats.isEmpty {
            let alertManager = AlertManager(VC: self)
            let alert = alertManager.error(message: "Please select at least 1 one service")
            self.present(alert, animated: true, completion: nil)
            
            return
            
        } else {
            self.setupLoading()
        }
        
        self.viewModel
            .findExperts(state        : "California",
                         category     : chosenCat,
                         subCategories: cats)
            .continueWith { [weak self] (experts) in
                guard let strongSelf = self else {return}
                
                DispatchQueue.main.async {
                    switch experts.result != nil {
                    case true:
                        guard let exps = experts.result else {return}
                        strongSelf.convertExpertPicDataToImage(experts: exps!)
                        
                    case false:
                        if experts.error != nil {
                            let alertmanager = AlertManager(VC: strongSelf)
                            let alert = alertmanager.error(message: "\(experts.error!.localizedDescription)")
                            strongSelf.present(alert, animated: true, completion: nil)
                        }
                    }
                    strongSelf.collapseLoading()
                }
        }
    }
    
    private func refresh(){
        SearchResultManager.shared.expertsToDisplay.removeAll()
        SearchResultManager.shared.subCatToSearchFor.removeAll()
    }
    
    private func cleanUp() {
        BriizeManager.shared.rxExpertModelArray.value.removeAll()
        
        let cells = self.suategoryCollectionView.visibleCells
        for cell in cells {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
    private func setupLoading() {
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
    }
    
    // MARK: Button Pressed Methods
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.submitSubCategoriesAndFindExpert()
    }
    
}

