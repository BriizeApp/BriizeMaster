//
//  CameraViewController.swift
//  Briize
//
//  Created by Admin on 11/12/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class BeautyExpertSettingsMenuViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    fileprivate let menuSettings:[String] = ["Services", "Payment", "Instagram", "Support", "Log-Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.settingsTableView.delegate        = self
        self.settingsTableView.dataSource      = self
        self.settingsTableView.tableFooterView = UIView()
        
        SideMenuManager.menuFadeStatusBar            = false
        SideMenuManager.menuWidth                    = 200.0
        SideMenuManager.menuAnimationPresentDuration = 0.2
        SideMenuManager.menuAnimationDismissDuration = 0.2
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

extension BeautyExpertSettingsMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        //cell.textLabel?.font          = UIFont(name: "Lobster-Regular", size: 26.0)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor     = kPinkColor
        cell.textLabel?.text          = self.menuSettings[indexPath.row]
        
        return cell
    }
    
}
