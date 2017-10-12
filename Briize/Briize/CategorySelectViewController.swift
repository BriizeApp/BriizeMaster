//
//  CategorySelectViewController.swift
//  Briize
//
//  Created by Admin on 8/15/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

class CategorySelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuImage: UIImageView!
    
    let blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        self.menuImage.layer.cornerRadius = 25
        self.menuImage.layer.borderColor = UIColor.white.cgColor
        self.menuImage.layer.borderWidth = 2.0
        self.catTableView.delegate = self
        self.catTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //
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
    
    @IBOutlet weak var catTableView: UITableView!
    
    
    
    
    var menuOpened:Bool = false
    let titles:[String]  = ["Nails", "Make-Up", "Eyelashes", "Eyebrows", "Hair"]
    let pics  :[UIImage] = [#imageLiteral(resourceName: "cat1"),#imageLiteral(resourceName: "cat5"),#imageLiteral(resourceName: "cat2"),#imageLiteral(resourceName: "cat4"),#imageLiteral(resourceName: "cat3")]
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell  = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        let image = cell.catImage.image
        let text  = cell.catTitle.text
        let txt   = text
        let img = image
        tempPic = img!
        tempTitle = txt!
        
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
