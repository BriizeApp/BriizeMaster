//
//  APIManager.swift
//  Briize
//
//  Created by Admin on 10/20/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import Parse
import BoltsSwift

public class APIManager {
    
    func createUserAccount(firstname:String,lastname:String,email:String,password:String,phone:String, sender:UIViewController) {
        let isExpert     = UserDefaults.standard.bool(forKey: "isExpert")
        
        let user = PFUser()
        user.username = email
        user.password = password
        user.email    = email
        
        user["phone"]    = phone
        user["fullName"] = firstname + " " + lastname
        user["isExpert"] = isExpert
        
        self.userSignUp(user: user, sender: sender)
    }
    
    func userSignUp(user:PFUser, sender:UIViewController) {
        let alertManager = AlertManager(VC: sender)
        user.signUpInBackground(block: { (success, error) in
            if error != nil {
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    let alert = alertManager.errorOnSignUp()
                    sender.present(alert, animated: true, completion: nil)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    let alert = alertManager.successOnSignUp()
                    sender.present(alert, animated: true, completion: nil)
                    return
                }
            }
        })
    }
    
}
