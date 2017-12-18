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
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.locationTextField.delegate = self
        
        self.singUpButton.roundCorners(cornerRadius: 20.0)
        let yourBackImage = UIImage(named: "ic_arrow_back_white")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: yourBackImage, style: .plain, target: self, action: #selector(backTapped))
        self.choosePhotoButton.titleLabel?.text = "\nChose image"
        self.imagePicker.delegate = self
        
        self.profileImage.roundCorners(cornerRadius: self.profileImage.frame.size.width/2)
    }
    
    func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        self.navigationController?.isNavigationBarHidden = false
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
        if self.emailTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            //Check if email fields are empty or whitespaced
            Global.displayClassicAlert(message: "Please enter email before singing up", viewController: self)
        }else if self.passwordTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty && self.confirmPasswordTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            //Check if password fields are empty or whitespaced
            Global.displayClassicAlert(message: "Please enter password before before singing up", viewController: self)
        }else if self.passwordTextField.text != self.confirmPasswordTextField.text{
            //Passwords must match
            Global.displayClassicAlert(message: "Passwords must match", viewController: self)
        }else if self.locationTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            //Check if location fields are empty or whitespaced
            Global.displayClassicAlert(message: "Please choose location before singing up", viewController: self)
        }else{
            self.fireBaseCreateUser(username: self.emailTextField.text!, password: self.confirmPasswordTextField.text!, location: self.locationTextField.text!)
        }
    }
    
    private func fireBaseCreateUser(username: String, password: String, location: String){
        Global.startActivity(view: self.view)
        
        Auth.auth().createUser(withEmail: username, password: password, completion: { (user, error) in
            if error == nil{
                let chosenImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
                Storage.storage().reference().child("profilePhotos").child("\(NSUUID().uuidString).jpg").putData(chosenImage!, metadata: nil, completion: { (metaData, error) in
                    if error == nil{
                        Global.DB_REF_URL.child("Users").child(user!.uid).setValue(["username" : username, "password" : password, "location" : location, "profileImageUrl" : metaData!.downloadURL()!.absoluteString], withCompletionBlock: { (error, db_ref) in
                                if error == nil{
                                    
                                    Auth.auth().signIn(withEmail: user!.email!, password: password, completion: { (user, error) in
                                        if error == nil{
                                            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                                Global.stopActivity()
                                                if error == nil{
                                                    self.navigationController?.popToRootViewController(animated: true)
                                                    Global.displayClassicAlert(message: "Email has been sent to your adress, please confirm your account", viewController: self.view.window!.rootViewController!)
                                                    print("Image uploaded")
                                                }else{
                                                    Auth.auth().currentUser?.delete(completion: { (error) in
                                                        if error == nil{
                                                            print("User removed")
                                                        }
                                                    })
                                                    
                                                    print("Error on sending email: \(error?.localizedDescription ?? "Error occured")")
                                                }
                                            })
                                        }
                                    })
                                }else{
                                    print("Error uploading image \(String(describing: error?.localizedDescription))")
                                }
                        })
                    }else{
                        Global.stopActivity()
                        print("Error uploading to storage \(String(describing: error?.localizedDescription))")
                    }
                })
            }else{
                print("Error on creating: \(String(describing: error))")
                Global.displayClassicAlert(message: error!.localizedDescription, viewController: self)
                Global.stopActivity()
            }
        })
    }
    
    @IBAction func addPhotoAction(_ sender: Any) {
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImage.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
