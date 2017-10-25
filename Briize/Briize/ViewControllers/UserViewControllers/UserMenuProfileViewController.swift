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

class UserMenuProfileViewController : UIViewController {
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var randomArray:[String] = ["Find An Expert","Previous Orders","Settings","Log Out"]
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.userTableView.delegate   = self
        self.userTableView.dataSource = self
        
        SideMenuManager.menuFadeStatusBar = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userProfileImage.layer.cornerRadius = 75
        self.userProfileImage.layer.borderWidth  = 1
        self.userProfileImage.layer.borderColor  = UIColor.white.cgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
