//
//  CreateAccountViewController.swift
//  Briize
//
//  Created by Admin on 10/20/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//

import Foundation
import UIKit
import BoltsSwift

class CreateAccountViewController:UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var photoOfCertButtonOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stateTextField: UITextField!
    
    private var states:[String] = kUSStates
    private var selectedState = ""
    private var myTextFields:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.signingUpAsExpert()
    }
    
    deinit {
        self.cleanUpUI()
    }
    
    //Helper Methods
    private func setupUI() {
        self.photoOfCertButtonOutlet.layer.cornerRadius = 8
        self.photoOfCertButtonOutlet.backgroundColor    = kPinkColor
        
        self.myTextFields.append(self.firstNameTextField)
        self.myTextFields.append(self.lastNameTextField)
        self.myTextFields.append(self.emailTextField)
        self.myTextFields.append(self.passwordTextField)
        self.myTextFields.append(self.phoneNumberTextField)
        self.myTextFields.append(self.stateTextField)
        self.setupTextFields(textFields: self.myTextFields)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name    : NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name    : NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupPicker(){
        let statesPickerView                     = UIPickerView()
        statesPickerView.showsSelectionIndicator = true
        statesPickerView.backgroundColor         = .white
        statesPickerView.delegate                = self
        statesPickerView.dataSource              = self
        
        let toolBar             = UIToolbar()
        toolBar.barStyle        = UIBarStyle.default
        toolBar.isTranslucent   = true
        toolBar.tintColor       = .red
        toolBar.backgroundColor = .white
        toolBar.sizeToFit()
        
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton   = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePickerAction))
        toolBar.setItems([spaceButton, doneButton, spaceButton2], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.stateTextField.inputView = statesPickerView
        self.stateTextField.inputAccessoryView = toolBar
    }
    
    func donePickerAction() {
        self.stateTextField.resignFirstResponder()
    }
    
    private func signingUpAsExpert() {
        let isExpert = UserDefaults.standard.bool(forKey: "isExpert")
        if isExpert != true {
            self.photoOfCertButtonOutlet.isHidden = true
        }
        else {
            self.photoOfCertButtonOutlet.isHidden = false
        }
    }
    
    private func setupTextFields(textFields:[UITextField]) {
        for field in textFields {
            field.delegate = self
            
            let bottomLine   = CALayer()
            bottomLine.frame = CGRect(x: 0.0,y: field.frame.height - 1, width: field.frame.width, height: 1.0)
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
            case stateTextField:
                field.attributedPlaceholder = NSAttributedString(string: "State You Live In",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
            default:
                fatalError("textFields Magically don't exist on create account controller")
            }
        }
    }
    
    private func createAccount() {
        let apiManager = APIManager()
        guard let firstName  = self.firstNameTextField.text,
            let lastName     = self.lastNameTextField.text,
            let email        = self.emailTextField.text,
            let password     = self.passwordTextField.text,
            let phoneNumber  = self.phoneNumberTextField.text,
            let state        = self.stateTextField.text
            else {
                return
        }
        apiManager.createUserAccount(firstname: firstName,
                                     lastname : lastName,
                                     email    : email,
                                     password : password,
                                     phone    : phoneNumber,
                                     state    : state,
                                     sender   : self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var contentInset:UIEdgeInsets    = scrollView.contentInset
        contentInset.bottom              = 250
        scrollView.contentInset          = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets                = UIEdgeInsets.zero
        scrollView.contentInset          = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func cleanUpUI() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        scrollView.becomeFirstResponder()
        
        return false
    }
    
    // Button Methods
    @IBAction func photoOfCertButtonPressed(_ sender: Any) {
        //Upload Image Certification
    }
    
    @IBAction func addAccountButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.createAccount()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Picker Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedState = self.states[row]
        self.stateTextField.text = selectedState
    }
    
}
