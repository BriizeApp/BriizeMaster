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
    
    @IBOutlet weak var beautyTableView: UITableView!
    var names:[String] = []
    var specialties:[String] = []
    var zipcodes:[String] = []
    var imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beautyTableView.delegate = self
        self.beautyTableView.dataSource = self
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        cell.expertName.text = searchResults.expertsToDisplay[row].fullName
        cell.expertDistance.text = String("$" + "\(searchResults.expertsToDisplay[row].subCatPrice)")
        cell.expertImage.layer.cornerRadius = 50
        
        return cell
    }
    
}
