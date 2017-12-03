//
//  LoginViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/27/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import PasswordTextField
import TextFieldEffects
import IHKeyboardAvoiding
import Firebase
import Spring

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordView: SpringView!
    @IBOutlet weak var userNameView: SpringView!
    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var singInButton: UIButton!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome")
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.singInButton.layer.masksToBounds = true
        self.singInButton.layer.cornerRadius = 20
        
        if let userDict = retrieveDictionary(withKey: "loggedInUser") {
            self.firebaseUserLogin(username: userDict["username"]! as String, password: userDict["password"]! as String)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func firebaseUserLogin(username: String, password: String){
        AIAppState.sharedInstance.startActivity(view: self.view)
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user, error) in
            if error == nil{
                if user!.isEmailVerified{
                    AIAppState.sharedInstance.stopActivity()
                    print("No error on login")
                    let userDict = [
                        "username" : username,
                        "password" : password
                    ]
                    let archiver = NSKeyedArchiver.archivedData(withRootObject: userDict)
                    UserDefaults.standard.set(archiver, forKey: "loggedInUser")
                    self.performSegue(withIdentifier: "showStartViewController", sender: nil)
                }else{
                    AIAppState.sharedInstance.stopActivity()
                    if self.counter > 0{
                        self.displayAlert(message: "Resend you verification email?", viewController: self)
                        self.counter += 1
                    }else{
                        self.displayClassicAlert(message: "Please confirm you email adress", viewController: self)
                        self.counter += 1
                    }
                }
                
            }else{
                print("Error on login: \(String(describing: error))")
                self.displayClassicAlert(message: "Email or Password do not match to our records\nPlease try again", viewController: self)
                AIAppState.sharedInstance.stopActivity()
                
            }
        })
    }
    
    func retrieveDictionary(withKey key: String) -> [String: String]? {
        
        // Check if data exists
        guard let data = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        
        // Check if retrieved data has correct type
        guard let retrievedData = data as? Data else {
            return nil
        }
        
        // Unarchive data
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        return unarchivedObject as? [String: String]
    }

    @IBAction func singInAction(_ sender: Any) {
        if self.usernameField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            self.userNameView.animation = "shake"
            self.userNameView.animate()
        }else if self.passwordField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            self.passwordView.animation = "shake"
            self.passwordView.animate()
        }else{
            if AIAppState.sharedInstance.validateEmailWithString(email: self.usernameField.text!) == true{
                self.firebaseUserLogin(username: self.usernameField.text!, password: self.passwordField.text!)
            }else{
               self.displayClassicAlert(message: "Please enter valid credentials", viewController: self)
            }
        }
    }
    @IBAction func singUpAction(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.performSegue(withIdentifier: "loginToRegister", sender: nil)
    }
    
    
    
    func displayClassicAlert(message: String, viewController: UIViewController){
        let alertController: UIAlertController = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true,completion: nil)
    }
    
    func displayAlert(message: String, viewController: UIViewController){
        let alertController: UIAlertController = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
            print("No Pressed")
        }
        alertController.addAction(noAction)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            print("Yes Pressed")
            if self.counter > 0{
                AIAppState.sharedInstance.startActivity(view: self.view)
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                    if error == nil{
                        AIAppState.sharedInstance.stopActivity()
                        self.displayClassicAlert(message: "Email has been sent to your adress, please confirm your account", viewController: self)
                    }
                })
            }
        }
        
        alertController.addAction(yesAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
