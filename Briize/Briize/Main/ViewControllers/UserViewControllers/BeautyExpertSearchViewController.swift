//
//  BeautyExpertSearchViewController.swift
//  Briize
//
//  Created by Admin on 8/15/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import Parse

class BeautyExpertSearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var expertFilterSegmentControl: UISegmentedControl!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var beautyTableView: UITableView!
    @IBOutlet weak var tableContainerTopConstraint: NSLayoutConstraint!
    
    var names:[String] = []
    var specialties:[String] = []
    var zipcodes:[String] = []
    var imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.expertFilterSegmentControl.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableContainerTopConstraint.constant = -93
            self.view.layoutIfNeeded()
        }) {
            finished in
            
            if finished == true {
                UIView.animate(withDuration: 0.3, animations: {
                    self.expertFilterSegmentControl.alpha = 1
                })
            }
        }
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    private func setupUI(){
        self.tableContainerTopConstraint.constant = -45
        
        self.beautyTableView.delegate   = self
        self.beautyTableView.dataSource = self
        
        self.beautyTableView.layer.borderWidth = 1.0
        self.beautyTableView.layer.borderColor = UIColor.white.cgColor
        self.beautyTableView.layer.cornerRadius    = 18
        self.tableContainerView.layer.cornerRadius = 18
        
        let frameSize = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.headerImageView.frame.height)
        let overlay = UIView(frame: frameSize)
        overlay.backgroundColor = .black
        overlay.alpha = 0.7
        self.headerImageView.insertSubview(overlay, at: 0)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        kRxExpertArray.value = []
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultManager.shared.expertsToDisplay.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let searchResults = SearchResultManager.shared
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cece", for: indexPath) as! BeautyExpertResultTableCell
        cell.expertImage.layer.cornerRadius = 60
        cell.expertName.text                = searchResults.expertsToDisplay[row].fullName
        cell.expertDistance.text            = String("$" + "\(searchResults.expertsToDisplay[row].subCatPrice)")
        cell.expertImage.image              = searchResults.expertsToDisplay[row].profileImage
        
        return cell
    }
    
}
