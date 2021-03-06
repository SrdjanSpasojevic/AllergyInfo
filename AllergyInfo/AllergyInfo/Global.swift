//
//  Global.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 12/17/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import FirebaseDatabase
import NVActivityIndicatorView


class Global: NSObject
{
    
    //MARK: Loader
    static var nvaActivity : NVActivityIndicatorView!
    static var progressHUD : AIProgressHud = AIProgressHud()
    static let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    static var blurEffectView : UIVisualEffectView = UIVisualEffectView()
    static var userPhoto = ""
    static let homeCellIdentifier = "homeCellIdentifier"
    
    //MARK: Firebase Database
    static var DB_REF_URL = Database.database().reference()
    
    static func startActivity(view: UIView){
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let frame = CGRect(x: view.bounds.size.width/2, y: view.bounds.size.height/2, width: 80, height: 80)
        self.nvaActivity = NVActivityIndicatorView(frame: frame, type: .ballScaleMultiple, color: UIColor.white, padding: 0)
        self.nvaActivity.center = UIApplication.shared.keyWindow!.center
        UIApplication.shared.keyWindow?.addSubview(blurEffectView)
        blurEffectView.alpha = 0.7
        UIApplication.shared.keyWindow?.addSubview(self.nvaActivity)
        self.nvaActivity.startAnimating()
    }
    
    static func startCustomActivity(view: UIView, type: NVActivityIndicatorType){
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let frame = CGRect(x: view.bounds.size.width/2, y: view.bounds.size.height/2, width: 80, height: 80)
        self.nvaActivity = NVActivityIndicatorView(frame: frame, type: type, color: UIColor.white, padding: 0)
        self.nvaActivity.center = UIApplication.shared.keyWindow!.center
        UIApplication.shared.keyWindow?.addSubview(blurEffectView)
        blurEffectView.alpha = 0.7
        UIApplication.shared.keyWindow?.addSubview(self.nvaActivity)
        self.nvaActivity.startAnimating()
    }
    
    static func stopActivity(){
        //self.progressHUD.hideHUD()
        self.nvaActivity.stopAnimating()
        self.blurEffectView.removeFromSuperview()
    }
    
    
    static func displayClassicAlert(message: String, viewController: UIViewController){
        let alertController: UIAlertController = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true) {
            
        }
    }
    
    static func writeArchiveToDisk(withDict dict: [String : Any], withKey key: String) {
        
        let archiver = NSKeyedArchiver.archivedData(withRootObject: dict)
        UserDefaults.standard.set(archiver, forKey: key)
        
    }
    
    static func retrieveDictionaryFromDisk(withKey key: String) -> [String: Any]? {
        
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
        return unarchivedObject as? [String: Any]
    }
    
    static func deleteDictionaryFromDisk(withKey key: String, completion: @escaping (_ dataLoaded: Bool) -> Void){
        
        if UserDefaults.standard.object(forKey: key) != nil
        {
            UserDefaults.standard.removeObject(forKey: key)
            completion(true)
        }
        else
        {
            completion(false)
        }
    }
    
    private static func setSingOutData(){
        let userDict = [
            "username" : "",
            "password" : ""
        ]
        let archiver = NSKeyedArchiver.archivedData(withRootObject: userDict)
        UserDefaults.standard.set(archiver, forKey: "loggedInUser")
    }
    
    //MARK: Validate email
    static func validateEmailWithString(email: String) -> Bool {
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
extension UILabel {
    @objc public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased()
            var fontName = newValue
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight"
            }
            self.font = UIFont(name: fontName, size: 15.0)
        }
    }
}
