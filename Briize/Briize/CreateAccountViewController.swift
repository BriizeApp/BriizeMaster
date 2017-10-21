//
//  CreateAccountViewController.swift
//  Briize
//
//  Created by Admin on 10/20/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountViewController:UIViewController, UITextFieldDelegate {
    
    private var myTextFields:[UITextField] = []
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var photoOfCertButtonOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    deinit {
        self.cleanUpUI()
    }
    
    private func setupUI() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name    : NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name    : NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.photoOfCertButtonOutlet.layer.cornerRadius = 8
        
        self.myTextFields.append(self.firstNameTextField)
        self.myTextFields.append(self.lastNameTextField)
        self.myTextFields.append(self.emailTextField)
        self.myTextFields.append(self.passwordTextField)
        self.myTextFields.append(self.phoneNumberTextField)
        self.setupTextFields(textFields: self.myTextFields)
    }
    
    private func setupTextFields(textFields:[UITextField]) {
        for field in textFields {
            field.delegate = self
            
            let bottomLine   = CALayer()
            bottomLine.frame = CGRect(x:0.0,y: field.frame.height - 1,
                                      width  : field.frame.width + 30,
                                      height : 1.0)
            bottomLine.backgroundColor = UIColor.white.cgColor
            
            field.borderStyle = UITextBorderStyle.none
            field.layer.addSublayer(bottomLine)
            
            switch field {
            case firstNameTextField:
                field.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
            case lastNameTextField:
                field.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
            case emailTextField:
                field.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
            case passwordTextField:
                field.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
            case phoneNumberTextField:
                field.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
            default:
                print("Error on textFields")
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = 226
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func cleanUpUI() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        scrollView.becomeFirstResponder()
        
        return false
    }
    
    @IBAction func photoOfCertButtonPressed(_ sender: Any) {
        //Upload Image Certification
    }
    
    @IBAction func addAccountButtonPressed(_ sender: Any) {
      
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
