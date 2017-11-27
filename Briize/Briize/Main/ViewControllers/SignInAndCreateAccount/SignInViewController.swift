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

class SignInViewController: UIViewController,UINavigationControllerDelegate{
    
    fileprivate var player = AVPlayer()
    fileprivate var overlay : UIView?
    fileprivate var loader  : NVActivityIndicatorView?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupBGVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupSubViews()
        self.playBGVideo()
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
        self.usernameTextview.text?.removeAll()
        self.passwordTextview.text?.removeAll()
        self.collapseLoading()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.signInBUttonOutlet.layer.borderWidth  = 2
        self.signInBUttonOutlet.layer.borderColor  = UIColor.white.cgColor
        self.signInBUttonOutlet.layer.cornerRadius = 25
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
    
    private func setupLoading() {
        self.player.pause()
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = .black
        overlay!.alpha = 0.8
        
        loader = NVActivityIndicatorView(frame  : CGRect(x: 0,y: 0,width: 60.0,height: 60.0),
                                         type   : .ballGridPulse,
                                         color  : kPinkColor,
                                         padding: nil)
        loader!.center = overlay!.center
        overlay?.addSubview(loader!)
        view.addSubview(overlay!)
        
        loader!.startAnimating()
    }
    
    func collapseLoading() {
        loader!.stopAnimating()
        overlay?.removeFromSuperview()
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
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setupBGVideo() {
        let vu = UIView(frame: self.view.frame)
        vu.backgroundColor = .black
        vu.alpha = 0.6
        
        guard let path = Bundle.main.path(
            forResource : "briizeBGV",
            ofType: "mp4")
            else {
                debugPrint("briizeBGV.mp4 not found")
                return
        }
        let videoURL = URL(fileURLWithPath: path)
        self.player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        self.view.addSubview(vu)
    }
    
    private func playBGVideo() {
        self.player.play()
        self.loopVideo(player: player)
    }
    
    private func setupSubViews() {
        self.view.bringSubview(toFront: self.logoImageView)
        self.view.bringSubview(toFront: self.createAccountButtonOutlet)
        //self.view.bringSubview(toFront: self.eulaButtonOutlet)
        self.view.bringSubview(toFront: self.usernameTextview)
        self.view.bringSubview(toFront: self.passwordTextview)
        self.view.bringSubview(toFront: self.signInBUttonOutlet)
        self.view.bringSubview(toFront: self.forgotPasswordButtonOutlet)
        self.view.bringSubview(toFront: self.logInLabel)
    }
    
    private func loopVideo(player:AVPlayer) {
        NotificationCenter
            .default
            .addObserver(forName : NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                         object  : nil,
                         queue   : nil) { notification in
                            DispatchQueue.main.async {
                                player.seek(to: kCMTimeZero)
                                player.play()
                            }
        }
    }
    
    //MARK: Button Mthods
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        let alertManager = AlertManager(VC: self)
        alertManager.openCreateAccountAlert()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.setupLoading()
        self.login()
    }
    
}
