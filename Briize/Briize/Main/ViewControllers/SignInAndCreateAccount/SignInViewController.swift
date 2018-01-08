//
//  SignInViewController.swift
//  Briize
//
//  Created by Admin on 7/30/17.
//  Copyright © 2017 Miles Fishman. All rights reserved.
//
import Foundation
import UIKit
import AVKit
import AVFoundation
import NVActivityIndicatorView
import Parse

class SignInViewController: UIViewController, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    
    fileprivate var player  : AVPlayer!
    fileprivate var playerLayer : AVPlayerLayer!
    
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
    let thisLoader = NVActivityIndicatorPresenter.sharedInstance
    
    @IBOutlet weak var logoImageView             : UIImageView!
    @IBOutlet weak var usernameTextview          : UITextField!
    @IBOutlet weak var passwordTextview          : UITextField!
    @IBOutlet weak var signInBUttonOutlet        : UIButton!
    @IBOutlet weak var fillerTextLabel           : UILabel!
    @IBOutlet weak var createAccountButtonOutlet : UIButton!
    @IBOutlet weak var eulaButtonOutlet          : UIButton!
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    @IBOutlet weak var logInLabel                : UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBGVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupVideoObserver()
        self.setupSubViews()
        self.logOutCurrentUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cleanupVC()
    }
    
    deinit {
        print("\(self.description) - deinit successful")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Helper Methods
    private func logOutCurrentUser() {
        PFUser.logOut()
    }
    
    private func cleanupVC() {
        NotificationCenter.default.removeObserver(self)
        
        self.collapseLoading()
        self.usernameTextview.text?.removeAll()
        self.passwordTextview.text?.removeAll()
        self.player.pause()
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.overlay = UIView(frame: view.frame)
        self.overlay!.backgroundColor = .black
        self.overlay!.alpha = 0.6
        
        self.signInBUttonOutlet.layer.borderWidth          = 2
        self.signInBUttonOutlet.layer.borderColor          = kPinkColor.cgColor
        self.signInBUttonOutlet.layer.cornerRadius         = 25
        
        self.createAccountButtonOutlet.layer.cornerRadius  = 10
        self.forgotPasswordButtonOutlet.layer.cornerRadius = 10
        self.createAccountButtonOutlet.layer.borderWidth   = 1.0
        self.createAccountButtonOutlet.layer.borderColor   = UIColor.white.cgColor
        self.forgotPasswordButtonOutlet.layer.borderWidth  = 1.0
        self.forgotPasswordButtonOutlet.layer.borderColor  = UIColor.white.cgColor
        
        self.setupTextViews()
    }
    
    private func setupTextViews() {
        self.usernameTextview.borderStyle = UITextBorderStyle.none
        self.passwordTextview.borderStyle = UITextBorderStyle.none
        self.usernameTextview.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.passwordTextview.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.addBottomBorderToTextField(myTextField: self.usernameTextview)
        self.addBottomBorderToTextField(myTextField: self.passwordTextview)
    }
    
    private func addBottomBorderToTextField(myTextField:UITextField) {
        let bottomLine   = CALayer()
        bottomLine.frame = CGRect(x:0.0,y: myTextField.frame.height - 1,
                                  width  : myTextField.frame.width,
                                  height : 1.0)
        
        bottomLine.backgroundColor = UIColor.white.cgColor
        
        myTextField.borderStyle = UITextBorderStyle.none
        myTextField.layer.addSublayer(bottomLine)
    }
    
    private func login() {
        guard self.usernameTextview.text != nil && self.passwordTextview.text != nil else {
            let alertManager = AlertManager(VC:self)
            let alert = alertManager.errorOnSignUp()
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        let user = self.usernameTextview.text!
        let pass = self.passwordTextview.text!
        
        let apiManager = APIManager()
        apiManager.logIn(username: user,
                         password: pass,
                         sender  : self)
    }
    
    private func setupSubViews() {
        self.view.insertSubview(self.overlay!, at: 1)
        self.view.bringSubview(toFront: self.logoImageView)
        self.view.bringSubview(toFront: self.createAccountButtonOutlet)
        self.view.bringSubview(toFront: self.usernameTextview)
        self.view.bringSubview(toFront: self.passwordTextview)
        self.view.bringSubview(toFront: self.signInBUttonOutlet)
        self.view.bringSubview(toFront: self.forgotPasswordButtonOutlet)
        self.view.bringSubview(toFront: self.logInLabel)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setupLoading() {
        self.player.pause()
        
        let loaderSize   = CGSize(width: 60.0, height: 60.0)
        startAnimating(loaderSize,
                       message: "Loading Profile...",
                       messageFont: nil,
                       type: .ballGridPulse,
                       color: kPinkColor,
                       padding: nil,
                       displayTimeThreshold: nil,
                       minimumDisplayTime: nil,
                       backgroundColor: nil,
                       textColor: .white)
    }
    
    func collapseLoading() {
        stopAnimating()
        
    }
    
    // Background Video Methods
    private func setupVideoObserver() {
        self.player.play()
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(playerItemReachedEnd(notification:)),
                         name    : NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                         object  : self.player.currentItem)
    }
    
    private func setupBGVideo() {
        let url = Bundle.main.url(forResource : "briizeBGV", withExtension: "mp4")
        self.player = AVPlayer.init(url: url!)
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.playerLayer.frame = self.view.layer.frame
        
        self.player.actionAtItemEnd = .none
        self.player.play()
        
        self.view.layer.insertSublayer(self.playerLayer, at: 0)
    }
    
    func playerItemReachedEnd(notification: NSNotification) {
        self.player.seek(to: kCMTimeZero)
    }
    
    //MARK: Button Mthods
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        let alertManager = AlertManager(VC: self)
        alertManager.openCreateAccountAlert()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
//        self.usernameTextview.text = "miles.fishman@yahoo.com"
//        self.passwordTextview.text = "devguy123"
        
        self.setupLoading()
        self.login()
    }
    
}
