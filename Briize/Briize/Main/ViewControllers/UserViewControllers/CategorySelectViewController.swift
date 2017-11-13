//
//  CategorySelectViewController.swift
//  Briize
//
//  Created by Admin on 8/15/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class CategorySelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var catTableView: UITableView!
    
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
    let rxDisposeBag = DisposeBag()
    
    let blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        self.setupUI()
        self.bindObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if menuOpened == true {
            menuOpened = false
            blurEffectView.removeFromSuperview()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        self.menuImage.layer.cornerRadius = 25
        self.menuImage.layer.borderColor = UIColor.white.cgColor
        self.menuImage.layer.borderWidth = 2.0
        self.catTableView.delegate = self
        self.catTableView.dataSource = self
    }
    
    func setupLoading() {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = .black
        overlay!.alpha = 0.8
        
        loader = NVActivityIndicatorView(frame  : CGRect(x: 0,y: 0,width: 60.0,height: 60.0),
                                         type   : .ballGridPulse,
                                         color  : kPinkColor,
                                         padding: nil)
        loader!.center = overlay!.center
        overlay?.addSubview(loader!)
        
        view.addSubview(overlay!)
        
        loader!.startAnimating()
    }
    
    func collapseLoading() {
        if loader != nil {
            loader!.stopAnimating()
            overlay?.removeFromSuperview()
        }
    }
    
    func bindObservables() {
        kRxMenuImage.asObservable().subscribe(onNext: { [weak self] (profilePicture) in
            guard let strongSelf = self else {return}
            switch profilePicture != nil {
            case true :
                DispatchQueue.main.async {
                    guard let profilePic = profilePicture else {return}
                    strongSelf.menuImage.image = profilePic
                }
            case false:
                return
            }
            }, onError: nil,
               onCompleted: nil,
               onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
        
        kRxLoadingData.asObservable().subscribe(onNext: { [weak self] (loading) in
            guard let strongSelf = self else {return}
            switch loading == true {
            case true :
                DispatchQueue.main.async {
                    strongSelf.setupLoading()
                }
            case false:
                DispatchQueue.main.async {
                    strongSelf.collapseLoading()
                }
            }
            }, onError: nil,
               onCompleted: nil,
               onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
    }
    
    //MARK: TableView Methods
    var menuOpened:Bool  = false
    let titles:[String]  = ["Make-Up", "Eyes & Brows", "Hair", "Nails"]
    let pics  :[UIImage] = [#imageLiteral(resourceName: "cat2"),#imageLiteral(resourceName: "cat4"),#imageLiteral(resourceName: "cat3"),#imageLiteral(resourceName: "cat1")]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard  let cell  = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else {return}
        let image = cell.catImage.image!
        let text  = cell.catTitle.text!
        let txt   = text
        let img   = image
        BriizeManager.shared.subCategoriesForCategory(category: txt, img:img)
        
        self.performSegue(withIdentifier: "openSubCats", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coco", for: indexPath) as! CategoryTableViewCell
        let row = indexPath.row
        
        cell.catTitle.text  = titles[row]
        cell.catImage.image = pics[row]
        
        return cell
    }
    
    @IBAction func openMenuButtonPressed(_ sender: Any) {
        //Add Blur When Menu Opens
        menuOpened = true
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
