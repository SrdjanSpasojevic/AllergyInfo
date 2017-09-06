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
    @IBOutlet weak var viewToAvoid: UIView!
    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var singInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome")
        
        KeyboardAvoiding.avoidingView = self.viewToAvoid
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.singInButton.layer.masksToBounds = true
        self.singInButton.layer.cornerRadius = 20
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                self.performSegue(withIdentifier: "showStartViewController", sender: nil)
                AIAppState.sharedInstance.stopActivity()
                print("No error on login")
            }else{
                print("Error on login: \(error)")
                AIAppState.sharedInstance.stopActivity()
                self.displayAlert(message: "User has not been found, do you want to create a profile?", viewController: self)
            }
        })
    }
    
    func fireBaseCreateUser(username: String, password: String){
        AIAppState.sharedInstance.startActivity(view: self.view)
        FIRAuth.auth()?.createUser(withEmail: username, password: password, completion: { (user, error) in
            if error == nil{
                AIAppState.sharedInstance.stopActivity()
                AIAppState.sharedInstance.DB_REF_URL.child("UserProfiles").child(user!.uid).setValue([
                    "username" : username,
                    "password" : password
                    ])
                self.performSegue(withIdentifier: "showStartViewController", sender: nil)
            }else{
                print("Error on creating: \(error)")
                AIAppState.sharedInstance.stopActivity()
            }
        })
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
        
        
        viewController.present(alertController, animated: true) {
            
        }
    }
    
    func displayAlert(message: String, viewController: UIViewController){
        let alertController: UIAlertController = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
            print("No Pressed")
        }
        alertController.addAction(noAction)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            print("Yes Pressed")
            self.fireBaseCreateUser(username: self.usernameField.text!, password: self.passwordField.text!)
        }
        
        alertController.addAction(yesAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
