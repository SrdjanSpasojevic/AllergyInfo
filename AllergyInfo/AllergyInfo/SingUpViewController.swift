//
//  SingUpViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 9/7/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import PasswordTextField
import TextFieldEffects
import IHKeyboardAvoiding
import Firebase
import Spring
import MobileCoreServices

class SingUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    @IBOutlet weak var locationTextField: HoshiTextField!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorsPallete.navigationBarColor
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.locationTextField.delegate = self
        
        self.singUpButton.backgroundColor = ColorsPallete.navigationBarLabelColor
        self.singUpButton.setTitleColor(ColorsPallete.labelTintColor, for: .normal)
        self.singUpButton.roundCorners(cornerRadius: 20.0)
        
        ColorsPallete.setColors(to: [emailTextField, passwordTextField, confirmPasswordTextField, locationTextField], color: ColorsPallete.navigationBarColor, withOption: .backgroundColor)
        
        let yourBackImage = UIImage(named: "icn_m_arrowdown_white")
        self.backButton.setImage(yourBackImage, for: .normal)
        backButton.setTitle("", for: .normal)
        
        self.view.addSubview(backButton)
        
        
        self.choosePhotoButton.titleLabel?.text = "\nChose image"
        self.imagePicker.delegate = self
        
        self.profileImage.roundCorners(cornerRadius: self.profileImage.frame.size.width/2)
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
       self.navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func singUpAction(_ sender: Any) {
        
        if self.emailTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            
            //Check if email fields are empty or whitespaced
            Global.displayClassicAlert(message: "Please enter email before singing up", viewController: self)
            
        }else if self.passwordTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty && self.confirmPasswordTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            
            //Check if password fields are empty or whitespaced
            Global.displayClassicAlert(message: "Please enter password before before singing up", viewController: self)
            
        }else if self.passwordTextField.text != self.confirmPasswordTextField.text {
            
            //Passwords must match
            Global.displayClassicAlert(message: "Passwords must match", viewController: self)
            
        }else if self.locationTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            
            //Check if location fields are empty or whitespaced
            Global.displayClassicAlert(message: "Please choose location before singing up", viewController: self)
            
        }else {
            
            UserData.shared.username = self.emailTextField.text ?? ""
            UserData.shared.password = self.confirmPasswordTextField.text ?? ""
            UserData.shared.location = self.locationTextField.text ?? ""
            UserData.shared.profileImage = self.profileImage.image
            
            self.performSegue(withIdentifier: "singUpToQuestion", sender: nil)
        }
        
    }
    
    @IBAction func addPhotoAction(_ sender: Any)
    {
        self.showImageSourcetypeAlertVC()
    }
    
    private func showImageSourcetypeAlertVC()
    {
        
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraFlashMode = .off
            self.imagePicker.cameraCaptureMode = .photo
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.navigationBar.isTranslucent = false
            self.imagePicker.navigationBar.barTintColor = ColorsPallete.navigationBarColor
            self.imagePicker.navigationBar.tintColor =  .white
//            self.imagePicker.navigationBar.titleTextAttributes = [
//                NSAttributedStringKey.foregroundColorme : UIColor.white
//            ]
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoLibraryAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.profileImage.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    
    
    
    
    
    
    
    
    

}
