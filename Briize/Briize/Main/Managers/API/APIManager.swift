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
    
    func createUserAccount(firstname:String, lastname:String, email:String, password:String, phone:String, state:String, sender:UIViewController) {
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
    
    func findLiveExpertsInUserState(state:String, category:String, subCategories:[String]) -> Task<[ExpertModel]?> {
        let completionTask = TaskCompletionSource<[ExpertModel]?>()
        
        let query = PFQuery(className: "Experts")
        query.whereKey("state", equalTo: state)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                var expertArray:[ExpertModel] = []
                
                for o in objects! {
                    let online = o["isOnline"] as! Bool
                    if online == true  {
                        let name            = o["fullName"] as! String
                        let file            = o["profilePic"] as! PFFile
                        let currentLocation = o["currentLocation"] as! PFGeoPoint
                        
                        let expert = ExpertModel(fullName: name, profileImage: nil, profilePicFile: file, currentLocation: currentLocation, subCatPrice: 0)
                        expertArray.append(expert)
                    }
                }
                DispatchQueue.main.async {
                    completionTask.set(result: expertArray)
                }
            }
        }
        return completionTask.task
    }
    
    func findExpertsClosestToUser(userLocation:PFGeoPoint, experts: [ExpertModel], category:String, subCategories:[String]) -> Task<[ExpertModel]?>{
        let completionTask = TaskCompletionSource<[ExpertModel]?>()
        
        var expertsToUse:[ExpertModel] = []
        
        for e in experts {
            let distanceInMiles = e.currentLocation?.distanceInMiles(to: userLocation)
            print(distanceInMiles!)
            
            if distanceInMiles! <= 5.0 {
                expertsToUse.append(e)
            } else {
                continue
            }
        }
        completionTask.set(result: expertsToUse)
        
        return completionTask.task
    }
    
    func matchExpertsToChosenSubCategories(names: [ExpertModel], category:String, subCategories:[String]) -> Task<[ExpertModel]?> {
        let completionTask = TaskCompletionSource<[ExpertModel]?>()
        let expertNames    = names.map({$0.fullName!})
        
        var experts:[ExpertModel] = []
        var totalObjects  :Int = 0
        var objectsCounted:Int = 0
        
        if subCategories.count >= 0 {
            let query = PFQuery(className: category)
            query.whereKey("expertName", containedIn: expertNames)
            query.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    print("Successfully retrieved")
                    
                    if let objects = objects {
                        objectsCounted = objects.count
                        
                        var totalPrice:Int = 0
                        
                        for object in objects {
                            totalPrice = 0
                            totalObjects += 1
                            
                            var model:ExpertModel?
                            var objToUse:PFObject?
                            var sum:Int = 0
                            
                            for cat in subCategories {
                                let price = object[cat] as? Int ?? 0
                                if price != 0 {
                                    totalPrice += price
                                    sum        += 1
                                    objToUse = object
                                } else {
                                    objToUse = nil
                                    sum = 0
                                }
                            }
                            if objToUse != nil && sum == subCategories.count{
                                let name = objToUse!["expertName"] as! String
                                
                                for e in names {
                                    if e.fullName == name {
                                        model = ExpertModel(fullName       : name,
                                                            profileImage   : nil,
                                                            profilePicFile : e.profilePicFile,
                                                            currentLocation: e.currentLocation,
                                                            subCatPrice    : totalPrice)
                                    }
                                }
                                experts.append(model!)
                            }
                        }
                        if totalObjects == objectsCounted {
                            completionTask.set(result: experts)
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.localizedDescription)")
                }
            })
        } else {
            print("No Sub Categories Selected")
        }
        return completionTask.task
    }
    
    func logIn(username:String, password:String, sender: SignInViewController) {
        PFUser.logInWithUsername(inBackground : username,
                                 password     : password) { (user, error) in
                                    if error != nil {
                                        DispatchQueue.main.async {
                                            print(error!.localizedDescription)
                                            sender.collapseLoading()
                                            
                                            let alertManager = AlertManager(VC: sender)
                                            let alert = alertManager.errorOnSignUp()
                                            sender.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    } else {
                                        guard let user = user,
                                            let fullName = user["fullName"] as? String
                                            else {
                                                return
                                        }
                                        let isExpert = user["isExpert"] as! Bool
                                        
                                        self.pullPfrofilePhoto(nameOfUserorExpert: fullName,
                                                               isExpert          : isExpert)
                                            .continueWith(continuation: { (image) in
                                                var picture:UIImage?
                                                if let profilePic = image.result {
                                                    picture = profilePic
                                                }
                                                if isExpert == true {
                                                    if let img = picture {
                                                        ExpertModel.current.profileImage = img
                                                    }
                                                    DispatchQueue.main.async {
                                                        ExpertModel.current.fullName = fullName
                                                        sender.performSegue(withIdentifier: "showExpertProfile", sender: sender)
                                                    }
                                                } else {
                                                    if let img = picture {
                                                        kRxMenuImage.value = img
                                                        UserModel.current.profileImage = img
                                                    }
                                                    DispatchQueue.main.async {
                                                        UserModel.current.fullName = fullName
                                                        sender.performSegue(withIdentifier: "showUserProfile", sender: sender)
                                                    }
                                                }
                                            })
                                    }
        }
    }
    
    private func getDataFromImage(file:PFFile) -> Task<UIImage?> {
        let completionSource = TaskCompletionSource<UIImage?>()
        var image:UIImage? = nil
        
        file.getDataInBackground { (data, error) in
            if error == nil {
                if let imageData = data {
                    image = UIImage(data:imageData)
                    completionSource.set(result: image)
                }
            }
        }
        return completionSource.task
    }
    
    private func uploadProfilePhoto(file:PFFile) -> Task<UIImage?> {
        let completionSource = TaskCompletionSource<UIImage?>()
        
        var image:UIImage? = nil
        
        file.getDataInBackground { (data, error) in
            if error == nil {
                if let imageData = data {
                    image = UIImage(data:imageData)
                    completionSource.set(result: image)
                }
            }
        }
        return completionSource.task
    }
    
    private func pullPfrofilePhoto(nameOfUserorExpert:String, isExpert: Bool) -> Task<UIImage?> {
        let completionSource = TaskCompletionSource<UIImage?>()
        
        var image:UIImage? = nil
        var query:PFQuery? = nil
        
        switch isExpert {
        case true:
            query = PFQuery(className: "Experts")
        case false:
            query = PFQuery(className: "Clients")
        }
        let strongQuery = query!
        strongQuery.whereKey("fullName", equalTo: nameOfUserorExpert)
        strongQuery.findObjectsInBackground(block: { (objects, error) in
            if let error = error {
                print("error occured - \(error.localizedDescription)")
            } else {
                if objects != nil {
                    for o in objects! {
                        let file = o["profilePic"] as! PFFile
                        file.getDataInBackground { (data, error) in
                            if error == nil {
                                if let imageData = data {
                                    image = UIImage(data:imageData)
                                    completionSource.set(result: image)
                                }
                            }
                        }
                    }
                } else {
                    //handle no objects error
                }
            }
        })
        return completionSource.task
    }
    
}
