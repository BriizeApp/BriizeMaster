//
//  CategorySelectViewController.swift
//  Briize
//
//  Created by Admin on 8/15/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
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
    
    let viewModel         = CategorySelectViewModel()
    let rxDisposeBag      = DisposeBag()
    let rxLocationChecker = Variable<PFGeoPoint?>(UserModel.current.currentLocation)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configureTableView()
        self.bindObservables()
        self.bindProfileStateObservable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cleanUp()
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
        
        self.menuImage.layer.cornerRadius = 20
        self.menuImage.layer.borderColor  = UIColor.lightGray.cgColor
        self.menuImage.layer.borderWidth  = 1.0
        
        self.catTableView.layer.cornerRadius = 14
        self.catTableView.layer.borderWidth  = 1.0
        self.catTableView.layer.borderColor  = UIColor.lightGray.cgColor
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    
    private func configureTableView() {
        self.catTableView.rowHeight = 193
        self.catTableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let this = self else {return}
                let cell = this.catTableView.cellForRow(at: indexPath) as! CategoryTableViewCell
                let image = cell.catImage.image!
                let text  = cell.catTitle.text!
                
                let txt   = text
                let img   = image
                
                SearchResultManager.shared.chosenCategory = txt
                BriizeManager.shared.subCategoriesForCategory(category: txt, img:img)
                
                DispatchQueue.main.async {
                    this.catTableView.deselectRow(at: indexPath, animated: true)
                    this.performSegue(withIdentifier: "openSubCats", sender: self)
                }
            })
            .disposed(by: self.rxDisposeBag)
    }
    
    func bindObservables() {
        self.viewModel
            .categories
            .asObservable()
            .bind(to: self.catTableView.rx.items(
                cellIdentifier: "coco",
                cellType: CategoryTableViewCell.self)){ row, mainCategory, cell in
                    cell.alpha = 0
                    cell.category = mainCategory
                    
                    UIView.animate(withDuration: 1.0) {
                        cell.alpha = 1.0
                    }
            }
            .disposed(by: self.rxDisposeBag)
        
        self.rxLocationChecker
            .asObservable()
            .subscribe(onNext: {(geoPoint) in
                switch geoPoint == nil {
                case true:
                    _ = PFGeoPoint.geoPointForCurrentLocation(inBackground: { (currentPoint, error) in
                        if error == nil {
                            print(currentPoint!)
                            
                            let currentLocationGeoPoint = currentPoint!
                            UserModel.current.currentLocation = currentLocationGeoPoint
                            
                        } else {
                            print(error!.localizedDescription) //No error either
                        }
                    })
                    
                case false:
                    print("User has currentLocation")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            
            .disposed(by: self.rxDisposeBag)
        
        BriizeManager
            .shared
            .rxProfileImage
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
        
        BriizeManager
            .shared
            .rxLoadingData
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
    }
    
    func bindProfileStateObservable() {
        BriizeManager
            .shared
            .rxClientProfileState
            .asObservable()
            .delaySubscription(2.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (stateString) in
                guard let strongSelf = self else {return}
                
                switch stateString {
                case "Orders":
                    print("Profile Session - Orders")
                    
                case "Promo Code":
                    print("Profile Session - promo Code")
                    
                case "Support":
                    print("Profile Session - support")
                    strongSelf.handleSupportSetting()
                    
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
            guard let strongSelf = self else {return}
            
            if error == nil {
                DispatchQueue.main.async {
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    func handleSupportSetting() {
       self.sendEmail()
    }
    
    func cleanUp() {
        BriizeManager.shared.rxClientProfileState.value = "Default"
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
    
    @IBAction func openMenuButtonPressed(_ sender: Any) {
        //Add Blur When Menu Opens
        menuOpened = true
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension CategorySelectViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["Briizebeauty@gmail.com"])
        composeVC.setSubject("Inquiry")
        composeVC.setMessageBody("How can we help?", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}


