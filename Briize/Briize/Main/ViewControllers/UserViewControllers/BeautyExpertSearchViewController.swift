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
import Mapbox

class BeautyExpertSearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MGLMapViewDelegate {
    
    @IBOutlet weak var myMapView: UIView!
    @IBOutlet weak var expertFilterSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var beautyTableView: UITableView!
    @IBOutlet weak var tableContainerTopConstraint: NSLayoutConstraint!
    
    var map: MGLMapView?
    
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
        self.map?.delegate = nil
        self.map?.removeFromSuperview()
        self.map = nil
        
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
        self.expertFilterSegmentControl.layer.cornerRadius = 4
        self.expertFilterSegmentControl.layer.borderWidth = 0
    }
    
    private func setupMap() {
        self.map = MGLMapView(frame: self.myMapView.bounds, styleURL: URL(string:"mapbox://styles/mapbox/dark-v9")!)
        
        map?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map?.attributionButton.isHidden = true
        
        // Set the map’s center coordinate and zoom level.
        map?.setCenter(CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407), zoomLevel: 12, animated: false)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        map?.delegate = self
        self.myMapView.addSubview(self.map!)
        
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        
        // Add marker `hello` to the map.
        map?.addAnnotation(hello)
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
    
    // MARK: - Mapbox Delegates
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            annotationView!.backgroundColor = kPinkColor
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}


