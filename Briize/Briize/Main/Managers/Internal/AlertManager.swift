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
    
    func errorOnSignUp() -> UIAlertController {
        let alert = UIAlertController(title: "Something went wrong",
                                      message: "Please check your internet connection or make sure you filled out all the appropriate fields",
                                      preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Ok",
                                      style: .default)
        alert.addAction(actionOne)
        
        return alert
    }
    
    func error(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Something went wrong",
                                      message: message,
                                      preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Ok",
                                      style: .destructive)
        alert.addAction(actionOne)
        
        return alert
    }
    
    func successOnSignUp() -> UIAlertController {
        let alert = UIAlertController(title: "Congrats!",
                                      message: "Please go ahead and login using the email and password you registered with ",
                                      preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Got It",
                                      style: .default) { _ in
                                        DispatchQueue.main.async {
                                            self.viewController.dismiss(animated: true, completion: nil)
                                        }
        }
        alert.addAction(actionOne)
        
       return alert
    }
    
}
