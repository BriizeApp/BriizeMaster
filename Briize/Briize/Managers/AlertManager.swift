//
//  AlertManager.swift
//  Briize
//
//  Created by Admin on 10/20/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

public class AlertManager {
    var viewController:UIViewController
    
    init(VC:UIViewController) {
        viewController = VC
    }
    
    func openCreateAccountAlert() {
        let alert = UIAlertController(title: "Who do you want to sign up as?",
                                      message: "Please choose the type of profile you would like to create",
                                      preferredStyle: .actionSheet)
        
        let actionOne = UIAlertAction(title: "Beauty Expert",
                                      style: .default) { _ in
                                        UserDefaults.standard.set(true, forKey: "isExpert")
                                        self.viewController.performSegue(withIdentifier: "openCreateAccount", sender: self.viewController)
        }
        let actionTwo = UIAlertAction(title: "User",
                                      style: .default) { _ in
                                        UserDefaults.standard.set(false, forKey: "isExpert")
                                         self.viewController.performSegue(withIdentifier: "openCreateAccount", sender: self.viewController)
        }
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        
        DispatchQueue.main.async {
            self.viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
