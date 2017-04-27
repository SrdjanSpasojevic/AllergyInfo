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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewToAvoid: UIView!
    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var singInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome")
        self.navigationController?.isNavigationBarHidden = true
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
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func singInAction(_ sender: Any) {
        if self.usernameField.text == "1" && self.passwordField.text == "1"{
            self.performSegue(withIdentifier: "showStartViewController", sender: nil)
        }else{
            print("Wrong password")
        }
    }
    
}
