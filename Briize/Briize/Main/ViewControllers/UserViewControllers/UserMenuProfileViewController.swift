//
//  UserMenuProfileViewController.swift
//  Briize
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import Parse
import NVActivityIndicatorView

class UserMenuProfileViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
    var randomArray: [String] = ["Find An Expert","Previous Orders","Settings","Log Out"]
    var imagePicker: UIImagePickerController!
    var imageToSave: UIImage?
    
    //MARK:
    override func viewDidLoad() {
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userProfileImage.isUserInteractionEnabled = true
        userProfileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Helper Methods
    private func setupUI () {
        SideMenuManager.menuFadeStatusBar = false
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.userTableView.delegate   = self
        self.userTableView.dataSource = self
        self.userProfileImage.layer.cornerRadius = 75
        self.userProfileImage.layer.borderWidth  = 1
        self.userProfileImage.layer.borderColor  = UIColor.white.cgColor
        
        let userModel = UserModel.shared
        if userModel.profileImage == nil {
            return
        }
        else {
            guard let profilePic = userModel.profileImage else {return}
            self.userProfileImage.image = profilePic
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
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
            UserModel.shared.profileImage = photo
            kRxMenuImage.value            = photo
            kRxLoadingData.value          = true
            
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
 
}

extension UserMenuProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.randomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font          = UIFont(name: "Lobster-Regular", size: 26.0)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text          = self.randomArray[indexPath.row]
        
        return cell
    }
    
}