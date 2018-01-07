//
//  File.swift
//  Briize
//
//  Created by Admin on 9/3/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class ExpertProfilePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var settingsCollectionView: UICollectionView!
    @IBOutlet weak var expertInfoMainView: UIView!
    @IBOutlet weak var expertInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expertInfoViewSecondTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var expertIsOnlineLabel: UILabel!
    @IBOutlet weak var expertNameLabel   : UILabel!
    @IBOutlet weak var expertClientLabel : UILabel!
    @IBOutlet weak var expertRevenueLabel: UILabel!
    @IBOutlet weak var expertRatingLabel : UILabel!
    
    @IBOutlet weak var expertProfilePic : UIImageView!
    @IBOutlet weak var bgProfileImage   : UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    let viewModel    = ExpertProfilePageViewModel()
    let rxDisposeBag = DisposeBag()
    
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configureCollectionView()
        self.bindObservables()
        self.bindProfileStateObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentIntroAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cleanUp()
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    private func setupUI() {
        let expertModel = ExpertModel.current
        guard let fullName = expertModel.fullName else {return}
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.settingsCollectionView.alpha = 0
        
        self.expertInfoViewTopConstraint.constant       = 150
        self.expertInfoViewSecondTopConstraint.constant = 150
        
        self.expertInfoMainView.alpha = 0
        self.expertInfoMainView.layer.cornerRadius      = 12
        self.expertInfoMainView.layer.borderWidth       = 2.0
        self.expertInfoMainView.layer.borderColor       = kPinkColor.cgColor
        
        self.expertNameLabel.text    = fullName
        self.expertClientLabel.text  = "0"
        self.expertRevenueLabel.text = "$0.00"
        self.expertRatingLabel.text  = "5"
        
        self.expertProfilePic.alpha              = 0
        self.expertProfilePic.layer.cornerRadius = 75
        self.expertProfilePic.layer.borderColor  = kPinkColor.cgColor
        self.expertProfilePic.layer.borderWidth  = 2
        
        if let photo = expertModel.profileImage {
            self.expertProfilePic.image = photo
            self.bgProfileImage.image = photo
        }
    }
    
    private func configureGestures() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.expertProfilePic.isUserInteractionEnabled = true
        self.expertProfilePic.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func presentIntroAnimation() {
        UIView.animate(withDuration: 1.5) {
            self.settingsCollectionView.alpha = 1.0
            self.expertInfoMainView.alpha = 1.0
            self.expertProfilePic.alpha = 1.0
            self.expertInfoViewTopConstraint.constant = 16
            self.expertInfoViewSecondTopConstraint.constant = 16
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindObservables() {
        self.viewModel
            .iconPhotos
            .asObservable()
            .bind(to: self.settingsCollectionView.rx.items(
                cellIdentifier: "expertSettingCell",
                cellType: ExpertSettingCollectionViewCell.self)
            ) {
                row, icon, cell in
                cell.settingIcon.layer.cornerRadius = 12
                cell.icon = icon
            }
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
                }, onError: nil,
                   onCompleted: nil,
                   onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
    }
    
    func bindProfileStateObservable() {
        BriizeManager
            .shared
            .rxExpertProfileState
            .asObservable()
            .subscribe(onNext: { [weak self] (stateString) in
                guard let strongSelf = self else {return}
                
                switch stateString {
                case "Services":
                    strongSelf.handleExpertServices()
                    print("Profile Session - Orders")
                    
                case "Instagram":
                    strongSelf.handleInstagram()
                    print("Profile Session - Orders")
                    
                case "Payment":
                    strongSelf.handlePayment()
                    print("Profile Session - promo Code")
                    
                case "Support":
                    strongSelf.handleSupport()
                    print("Profile Session - support")
                    
                case "Log-Out":
                    print("Profile Session - Log-Out")
                    strongSelf.handleLogout()
                    
                default:
                    print("Profile Session - Default")
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rxDisposeBag)
    }
    
    private func handleLogout() {
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
    
    private func handleSupport() {
        
    }
    
    private func handlePayment() {
        
    }
    
    private func handleInstagram() {
        
    }
    
    private func handleExpertServices() {
        
    }
    
    private func configureCollectionView() {
        self.settingsCollectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self,
                    let cell = strongSelf.settingsCollectionView.cellForItem(at: indexPath) as? ExpertSettingCollectionViewCell,
                    let settingName = cell.icon?.settingName
                    else {
                        return
                }
                strongSelf.settingsCollectionView.deselectItem(at: indexPath, animated: true)
                
                BriizeManager.shared.rxExpertProfileState.value = settingName
            })
            .disposed(by: self.rxDisposeBag)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    
    private func cleanUp() {
        BriizeManager.shared.rxExpertProfileState.value = "Default"
    }
    
    //MARK: UIPicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let compressedImageData = image.jpeg(.lowest)
            else {
                return
        }
        let imageData = compressedImageData
        let imageFile = PFFile(name:"profileImage.png", data:imageData)
        
        let photo = UIImage(data: compressedImageData)
        self.expertProfilePic.image      = photo
        self.bgProfileImage.image        = photo
        ExpertModel.current.profileImage = photo
        
        BriizeManager.shared.rxLoadingData.value = true
        
        DispatchQueue.main.async {
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        guard let userPhoto = PFUser.current() else {return}
        let name = userPhoto["fullName"] as! String
        
        let query = PFQuery(className: "Experts")
        query.whereKey("fullName", equalTo: name)
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
                for o in objects {
                    o["profilePic"] = imageFile
                    o.saveInBackground(block: { (done, error) in
                        
                        if let error = error {
                            print (error.localizedDescription)
                        } else {
                            if done == true {
                                
                                DispatchQueue.main.async {
                                    BriizeManager.shared.rxLoadingData.value = false
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
}
