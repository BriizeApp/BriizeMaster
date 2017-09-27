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
//
class SignInViewController: UIViewController,UINavigationControllerDelegate{
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextview: UITextField!
    @IBOutlet weak var passwordTextview: UITextField!
    @IBOutlet weak var signInBUttonOutlet: UIButton!
    @IBOutlet weak var fillerTextLabel: UILabel!
    @IBOutlet weak var createAccountButtonOutlet: UIButton!
    @IBOutlet weak var eulaButtonOutlet: UIButton!
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    @IBOutlet weak var logInLabel: UILabel!
    
    @IBOutlet weak var loader: NVActivityIndicatorView!
    
    
    fileprivate var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.signInBUttonOutlet.layer.borderWidth  = 2
        self.signInBUttonOutlet.layer.borderColor  = UIColor.white.cgColor
        self.signInBUttonOutlet.layer.cornerRadius = 25
        
        view.addGestureRecognizer(tap)
        self.usernameTextview.borderStyle = UITextBorderStyle.none
        self.passwordTextview.borderStyle = UITextBorderStyle.none
        
        self.createAccountButtonOutlet.layer.cornerRadius  = 10
        self.forgotPasswordButtonOutlet.layer.cornerRadius = 10
        self.createAccountButtonOutlet.layer.borderWidth   = 1.0
        self.createAccountButtonOutlet.layer.borderColor   = UIColor.white.cgColor
        self.forgotPasswordButtonOutlet.layer.borderWidth  = 1.0
        self.forgotPasswordButtonOutlet.layer.borderColor  = UIColor.white.cgColor
        
        self.addBottomBorderToTextField(myTextField: self.usernameTextview)
        self.addBottomBorderToTextField(myTextField: self.passwordTextview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let vu = UIView(frame: self.view.frame)
        vu.backgroundColor = .black
        vu.alpha = 0.6
        
        guard let path = Bundle
            .main
            .path(forResource : "briizeBGV",
                  ofType      : "mp4")
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.bringSubview(toFront: self.logoImageView)
        self.view.bringSubview(toFront: self.createAccountButtonOutlet)
        //self.view.bringSubview(toFront: self.eulaButtonOutlet)
        self.view.bringSubview(toFront: self.usernameTextview)
        self.view.bringSubview(toFront: self.passwordTextview)
        self.view.bringSubview(toFront: self.signInBUttonOutlet)
        self.view.bringSubview(toFront: self.forgotPasswordButtonOutlet)
        self.view.bringSubview(toFront: self.logInLabel)
        
        self.player.play()
        self.loopVideo(player: player)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loopVideo(player:AVPlayer) {
        NotificationCenter
            .default
            .addObserver(forName : NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                         object  : nil,
                         queue   : nil) {
                            notification in
                            
                            player.seek(to: kCMTimeZero)
                            player.play()
        }
    }
    
    func addBottomBorderToTextField(myTextField:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0.0,y: myTextField.frame.height - 1, width:myTextField.frame.width + 30, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        myTextField.borderStyle = UITextBorderStyle.none
        myTextField.layer.addSublayer(bottomLine)
    }
    
    @IBAction func testAnimation(_ sender: Any) {
        
        loader.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

