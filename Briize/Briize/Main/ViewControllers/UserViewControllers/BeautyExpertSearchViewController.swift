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
import MapKit

class BeautyExpertSearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var expertFilterSegmentControl: UISegmentedControl!
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
        self.setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.expertFilterSegmentControl.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            //self.tableContainerTopConstraint.constant = -93
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
        self.mapView.removeFromSuperview()
        self.mapView = nil
        
        print("\(self.description) - deinit successful")
    }
    
    private func setupUI(){
        //self.tableContainerTopConstraint.constant = -45
        
        self.beautyTableView.delegate   = self
        self.beautyTableView.dataSource = self
        
        self.beautyTableView.layer.borderWidth = 1.0
        self.beautyTableView.layer.borderColor = UIColor.white.cgColor
        self.beautyTableView.layer.cornerRadius    = 18
        self.tableContainerView.layer.cornerRadius = 18
    }
    
    private func setupMap() {
        self.mapView.mapType = MKMapType.standard
        
        let location = CLLocationCoordinate2D(latitude: 23.0225,longitude: 72.5714)
        
        // 3)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // 4)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Miles Fishman"
        annotation.subtitle = "ios"
        mapView.addAnnotation(annotation)
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
        cell.expertImage.layer.cornerRadius = 50
        cell.expertName.text                = searchResults.expertsToDisplay[row].fullName
        cell.expertDistance.text            = String("$" + "\(searchResults.expertsToDisplay[row].subCatPrice)")
        cell.expertImage.image              = searchResults.expertsToDisplay[row].profileImage
        
        return cell
    }
    
}
