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
        imageArray.append(#imageLiteral(resourceName: "a"))
        imageArray.append(#imageLiteral(resourceName: "b"))
        imageArray.append(#imageLiteral(resourceName: "c"))
        imageArray.append(#imageLiteral(resourceName: "d"))
        imageArray.append(#imageLiteral(resourceName: "e"))
        imageArray.append(#imageLiteral(resourceName: "f"))
        imageArray.append(#imageLiteral(resourceName: "g"))
        imageArray.append(#imageLiteral(resourceName: "h"))
        imageArray.append(#imageLiteral(resourceName: "i"))
        imageArray.append(#imageLiteral(resourceName: "j"))
        
        self.beautyTableView.delegate = self
        self.beautyTableView.dataSource = self
        
        
//        let req = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users")!)
//        let session = URLSession.shared
//
//        DispatchQueue.global(qos: .utility).async {
//            session.dataTask(with: req) {data, response, err in
//                let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
//
//                for i in json {
//                    let dic = i as! NSDictionary
//
//                    self.names.append(dic["name"] as! String)
//                    self.specialties.append(dic["phone"] as! String)
//
//                    let add = dic["address"] as! NSDictionary
//                    let zip = add["zipcode"] as! String
//                    self.zipcodes.append(zip)
//                }
//                DispatchQueue.main.async {
//                    self.beautyTableView.reloadData()
//                }
//                print("\(json)")
//                }.resume()
//        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cece", for: indexPath) as! BeautyExpertResultTableCell
        let row = indexPath.row
        let searchResults = SearchResultManager.shared
        
        cell.expertName.text = searchResults.expertsToDisplay[row].fullName
        cell.expertDistance.text = searchResults.expertsToDisplay[row].subCatPrice
        
        cell.expertImage.layer.cornerRadius = 50
        
        return cell
    }
    
}
