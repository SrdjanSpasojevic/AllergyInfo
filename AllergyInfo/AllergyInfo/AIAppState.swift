//
//  AIAppState.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 9/6/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseDatabase

class AIAppState: NSObject {
    static let sharedInstance = AIAppState()
    
    //MARK: Loader
    var nvaActivity : NVActivityIndicatorView!
    var progressHUD : AIProgressHud = AIProgressHud()
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView : UIVisualEffectView = UIVisualEffectView()
    var userPhoto = ""
    
    //MARK: Firebase Database
    var DB_REF_URL = FIRDatabase.database().reference()
    
    func startActivity(view: UIView){
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let frame = CGRect(x: view.bounds.size.width/2, y: view.bounds.size.height/2, width: 80, height: 80)
        self.nvaActivity = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor.white, padding: 0)
        self.nvaActivity.center = view.center
        //self.progressHUD.showHUD()
        UIApplication.shared.keyWindow?.addSubview(blurEffectView)
        blurEffectView.alpha = 0.7
        UIApplication.shared.keyWindow?.addSubview(self.nvaActivity)
        self.nvaActivity.startAnimating()
    }
    
    func stopActivity(){
        //self.progressHUD.hideHUD()
        self.nvaActivity.stopAnimating()
        self.blurEffectView.removeFromSuperview()
    }

    
    func displayClassicAlert(message: String, viewController: UIViewController){
        let alertController: UIAlertController = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        alertController.addAction(okAction)
        
        
        viewController.present(alertController, animated: true) {
            
        }
    }
    
    //MARK: Validate email
    func validateEmailWithString(email: String) -> Bool {
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
}
