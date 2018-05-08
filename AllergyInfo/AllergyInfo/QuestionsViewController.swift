//
//  QuestionsViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 1/27/18.
//  Copyright © 2018 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import TextFieldEffects

class QuestionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tellUsInfoLabel: UILabel!
    @IBOutlet var questionsLabels: [HoshiTextField]!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yourBackImage = UIImage(named: "ic_arrow_back_white")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: yourBackImage, style: .plain, target: self, action: #selector(backTapped))
        
        self.view.backgroundColor = ColorsPallete.navigationBarLabelColor
        
        for textField in self.questionsLabels
        {
            textField.delegate = self
        }
        
        ColorsPallete.setColors(to: self.questionsLabels, color: ColorsPallete.navigationBarLabelColor, withOption: .backgroundColor)
        
        self.finishButton.roundCorners(cornerRadius: self.finishButton.bounds.width/2)
        self.finishButton.layer.shadowColor = UIColor.black.cgColor
        self.finishButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.finishButton.layer.shadowOpacity = 4.0
        self.finishButton.layer.shadowRadius = 10.0
        self.finishButton.layer.masksToBounds = false
    }
    
    @objc private func backTapped()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    @IBAction func finishSingUpAction(_ sender: Any)
    {
        if self.checkIfAllFieldsPassing()
        {
             self.finishSingUp()
        }
        else
        {
            Global.displayClassicAlert(message: "You have to fil out all the fields before finishing", viewController: self)
        }
    }
    
    private func checkIfAllFieldsPassing() -> Bool
    {
        var allFieldsPassing = false
        
        for (index, textField) in self.questionsLabels.enumerated()
        {
            if let text = textField.text,
                let placeholder = textField.placeholder,
                text != ""
            {
                UserData.shared.questionsDict[placeholder] = text
                
                if index == self.questionsLabels.count-1
                {
                    allFieldsPassing = true
                }
            }
        }
        
        return allFieldsPassing
    }

    
    private func finishSingUp()
    {
        let userData = UserData.shared
        
        guard let userImage = userData.profileImage else
        {
            return
        }
        
        AIAppState.sharedInstance.fireBaseCreateUser(userImage: userImage, username: userData.username, password: userData.password, location: userData.location, questions: userData.questionsDict, activityView: self.view) { (finished, error) in
            
            if finished
            {
                self.performSegue(withIdentifier: "questionsToLogin", sender: self)
                Global.displayClassicAlert(message: "Email has been sent to your adress, please confirm your account", viewController: self)
            }
            else
            {
                Global.displayClassicAlert(message: error!.localizedDescription, viewController: self)
                Global.stopActivity()
                
            }
            
        }
    }
}















