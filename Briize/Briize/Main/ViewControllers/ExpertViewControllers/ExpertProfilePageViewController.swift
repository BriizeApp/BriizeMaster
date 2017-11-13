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

class ExpertProfilePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var expertNameLabel: UILabel!
    @IBOutlet weak var expertClientLabel: UILabel!
    @IBOutlet weak var expertRevenueLabel: UILabel!
    @IBOutlet weak var expertRatingLabel: UILabel!
    @IBOutlet weak var expertProfilePic: UIImageView!
    @IBOutlet weak var phPic1: UIImageView!
    @IBOutlet weak var phPic2: UIImageView!
    @IBOutlet weak var phPic3: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    let rxDisposeBag: DisposeBag = DisposeBag()
    
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.setupUI()
        self.bindObservables()
    }

    override func viewWillAppear(_ animated: Bool) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        expertProfilePic.isUserInteractionEnabled = true
        expertProfilePic.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupUI() {
        let expertModel = ExpertModel.shared
    
        self.navigationController?.navigationBar.isHidden = true
        
        guard let fullName = expertModel.fullName else {return}
        self.expertNameLabel.text    = fullName
        self.expertClientLabel.text  = "0"
        self.expertRevenueLabel.text = "$0.00"
        self.expertRatingLabel.text  = "5"
        
        self.expertProfilePic.layer.cornerRadius = 100
        self.expertProfilePic.layer.borderColor  = UIColor.white.cgColor
        self.expertProfilePic.layer.borderWidth  = 2
        if let photo = expertModel.profileImage {
            self.expertProfilePic.image = photo
        }
        //demoContent
        let picArray:[UIImageView] = [phPic1,phPic2,phPic3]
        self.picModifier(arrayOfImages: picArray)
    }
    
    private func bindObservables() {
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
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
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
    
    //MARK: UIPicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let compressedImageData = image.jpeg(.lowest)
            else {
                return
        }
        let imageData = compressedImageData
        let imageFile = PFFile(name:"profileImage.png", data:imageData)
        
        DispatchQueue.main.async {
            let photo = UIImage(data: compressedImageData)
            self.expertProfilePic.image     = photo
            ExpertModel.shared.profileImage = photo
            
            kRxLoadingData.value = true
            
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        guard let userPhoto = PFUser.current() else {return}
        userPhoto["profilePhoto"] = imageFile
        userPhoto.saveInBackground { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                DispatchQueue.main.async {
                    kRxLoadingData.value = false
                }
            }
        }
    }
    
    
    func picModifier(arrayOfImages:[UIImageView]) {
        for i in arrayOfImages {
            i.layer.cornerRadius = 50
            i.layer.borderColor = UIColor.white.cgColor
            i.layer.borderWidth = 2
        }
    }
    @IBAction func exitButtonPressed(_ sender: Any) {
        
    }
    
}
