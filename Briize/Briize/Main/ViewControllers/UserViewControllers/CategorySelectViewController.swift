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
import Parse

class CategorySelectViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet weak var opnMenuButtonOutlet: UIButton!
    
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
    var locationManager = CLLocationManager()
    var menuOpened:Bool = false
    
    let titles:[String]  = ["Make-Up", "Eyes & Brows", "Hair", "Nails"]
    let pics  :[UIImage] = [#imageLiteral(resourceName: "cat2"),#imageLiteral(resourceName: "cat4"),#imageLiteral(resourceName: "cat3"),#imageLiteral(resourceName: "cat1")]
    let blurEffectView   = UIVisualEffectView()
    
    let rxDisposeBag      = DisposeBag()
    let rxLocationChecker = Variable<PFGeoPoint?>(UserModel.current.currentLocation)
    let rxProfileState    = Variable<String> (BriizeManager.shared.currentSessionProfileState)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if menuOpened == true {
            menuOpened = false
            blurEffectView.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kRxUserProfileState.value = "Default"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    private func setupUI() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
        self.menuImage.layer.cornerRadius = 25
        self.menuImage.layer.borderColor = UIColor.white.cgColor
        self.menuImage.layer.borderWidth = 2.0
        
        self.catTableView.delegate = self
        self.catTableView.dataSource = self
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
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
        kRxMenuImage
            .asObservable()
            .subscribe(onNext: { [weak self] (profilePicture) in
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
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
        
        kRxLoadingData
            .asObservable()
            .subscribe(onNext: { [weak self] (loading) in
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
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
        
        self.rxLocationChecker
            .asObservable()
            .subscribe(onNext: {(geoPoint) in
                switch geoPoint == nil {
                case true:
                    _ = PFGeoPoint.geoPointForCurrentLocation(inBackground: { (currentPoint, error) in
                        if error == nil {
                            print(currentPoint!)
                            UserModel.current.currentLocation = currentPoint
                            
                        } else {
                            print(error!.localizedDescription) //No error either
                        }
                    })
                    
                case false:
                    print("User has currentLocation")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
        
        kRxUserProfileState
            .asObservable()
            .subscribe(onNext: { [weak self] (stateString) in
                guard let strongSelf = self else {return}
                
                switch stateString {
                case "Orders":
                    print("Profile Session - Orders")
                    
                case "Promo Code":
                    print("Profile Session - promo Code")
                    
                case "Support":
                    print("Profile Session - support")
                    
                case "Log Out":
                    print("Profile Session - Log Out")
                    strongSelf.handleLogout()
                    
                default:
                    print("Profile Session - Default")
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
    }
    
    func handleLogout() {
        self.setupLoading()
        PFUser.logOutInBackground(block: { [weak self] (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self?.collapseLoading()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    
    @IBAction func openMenuButtonPressed(_ sender: Any) {
        //Add Blur When Menu Opens
        menuOpened = true
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension CategorySelectViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard  let cell  = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else {return}
        let image = cell.catImage.image!
        let text  = cell.catTitle.text!
        let txt   = text
        let img   = image
        
        SearchResultManager.shared.chosenCategory = txt
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
        
        cell.layoutSubviews()
        cell.catTitle.text  = titles[row]
        cell.catImage.image = pics[row]
        
        return cell
    }
    
}
