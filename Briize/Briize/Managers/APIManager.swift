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
    
    func createUserAccount(firstname:String,lastname:String,email:String,password:String,phone:String) -> Task<Bool> {
        let completionSource = TaskCompletionSource<Bool>()
        
        let isExpert = UserDefaults.standard.bool(forKey: "isExpert")
        
        let user = PFUser()
        user.username = email
        user.password = password
        user.email    = email
        
        user["phone"]    = phone
        user["fullName"] = firstname + " " + lastname
        user["isExpert"] = isExpert
        
        user.signUpInBackground(block: { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                completionSource.set(result: false)
            } else {
                completionSource.set(result: true)
            }
        })
        return completionSource.task
    }
    
    
}
