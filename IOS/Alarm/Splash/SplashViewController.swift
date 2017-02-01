//
//  ViewController.swift
//  SplashAnimation
//
//  Created by Connor Reid on 1/11/2016.
//  Copyright © 2016 Connor Reid. All rights reserved.
//

import UIKit
import ParticleSDK


class SplashViewController: UIViewController, HolderViewDelegate, UITextFieldDelegate {
    
    var holderView = HolderView()
    var uNameTextField: DCTextField = DCTextField()     //  Particle login
    var passwordTextField: DCTextField = DCTextField()
    var loginButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHolderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true    // Remove Animation Bar
        
        if(self.supportedInterfaceOrientations == UIInterfaceOrientationMask.portrait && UIDevice.current.orientation != UIDeviceOrientation.portrait)
        {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return .portrait;
    }

    func addHolderView() {
        holderView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.bounds.width,
                                  height: view.bounds.height)
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addPieces()
    }
    
    
    func addTextFields(){
        
        //  Create a blur effect for the background
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.0
        self.view.addSubview(blurEffectView)
        
        //  Dimension Control Variables
        let screenWidth = self.view.frame.width
        let textFieldStartWidth: CGFloat = 10
        let textFieldWidth = screenWidth > 350 ? 300 : screenWidth - 40
        let textFieldHeight: CGFloat = 40
        let textFieldX: CGFloat = (screenWidth / 2) - (textFieldWidth / 2)
        let textFieldY: CGFloat = 100
        let buttonX: CGFloat = (screenWidth / 2) + (textFieldWidth / 2) - 120
        let buttonRect = CGRect(x: buttonX, y: textFieldY + 100, width: 120, height: 30)
        
        self.uNameTextField = DCTextField(frame: CGRect(x: screenWidth/2, y: textFieldY, width: textFieldStartWidth, height: textFieldHeight), placeholderText: "")
        self.uNameTextField.returnKeyType = UIReturnKeyType.next
        self.uNameTextField.delegate = self
        
        self.view.addSubview(self.uNameTextField)
        
        self.passwordTextField = DCTextField(frame: CGRect(x: screenWidth/2, y: textFieldY + 50, width: textFieldStartWidth, height: textFieldHeight), placeholderText: "")
        self.passwordTextField.returnKeyType = UIReturnKeyType.done
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
        
        self.view.addSubview(self.passwordTextField)
        
        UIView.animate(withDuration: 0.2, animations: {
            //  Animate Text Fields (Expand from center)
            self.uNameTextField.frame = CGRect(x: textFieldX, y: textFieldY, width: textFieldWidth, height: textFieldHeight)
            self.passwordTextField.frame = CGRect(x: textFieldX, y: textFieldY + 50, width: textFieldWidth, height: textFieldHeight)
            // Animate Blur Effect
            blurEffectView.alpha = 0.3
            
        }, completion: ({finished in
            //  Update Placeholders
            self.uNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: Colours.placeholderTextColour])
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: Colours.placeholderTextColour])
            
            //  Add Button
            self.loginButton = UIButton(frame: buttonRect)
            self.loginButton.setTitle("Login", for: .normal)
            self.loginButton.showsTouchWhenHighlighted = true
            self.loginButton.addTarget(self, action: #selector(self.particleLogin), for: .touchUpInside)
            
            self.view.addSubview(self.loginButton)
        }))
    }
    
    //let comp: SparkCompletionBlock
    
    //  Login to the the particle cloud server
    func particleLogin(){
        let username: String! = self.uNameTextField.text
        let password: String! = self.passwordTextField.text
        ParticleAccountDetails.uName = username
        ParticleAccountDetails.pWord = password
        SparkCloud.sharedInstance().login(withUser: username, password: password) { (error:Error?) -> Void in
            if let e=error {
                print("Wrong credentials or no internet connectivity, please try again")
                dump(e)
            }
            else {
                print("Logged in")
                self.getDevices()
            }
        }
    }
    
    func getDevices(){
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[Any]?, error:Error?) -> Void in
            if let e = error {
                print("Check your internet connectivity (getDevices)")
                dump(e)
            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    for device in devices {
                        if (device.name != nil){
                            ParticleAccountDetails.devices.append(device.name!)
                            ParticleAccountDetails.devicesConnected.append(device.connected)
                        }
                    }
                }
                self.performSegue(withIdentifier: "SplashToAlarmSegue", sender: nil)
            }
        }
    }
    
    //  MARK:  Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.uNameTextField{
            textField.placeholder = "Username(Required)"
        }else if textField == self.passwordTextField {
            textField.placeholder = "Password"
        }
    }
    
    func animateLabel() {
        
        let letter = UILabel(frame: view.frame)
        letter.textColor = Colours.blue
        letter.font = UIFont(name: "HelveticaNeue-Thin", size: 100)
        letter.textAlignment = .center
        letter.text = "dC"
        letter.transform = letter.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(letter)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(), animations: ({
            letter.transform = letter.transform.scaledBy(x: 4.0, y: 4.0)
        }), completion: ({ finished in
            self.addTextFields()
        }))
    }
    
}

