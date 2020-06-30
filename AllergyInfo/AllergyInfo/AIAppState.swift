//
//  Global.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 9/6/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseDatabase
import Firebase

class AIAppState: NSObject {
    static let sharedInstance = AIAppState()
    
    var dataSource = [WeatherData]()
    var dataLoaded = false
    
    func fetchData(completion: @escaping (_ dataLoaded: Bool) -> Void){

        if self.dataSource.count > 0{
            self.dataSource.removeAll()
        }
        WeatherAPI().retrieveWeatherData { (data) in
            self.dataSource = data
            if self.dataSource.isEmpty{
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func fireBaseCreateUser(userImage: UIImage, username: String, password: String, location: String, questions: [String : String], activityView: UIView, completion: @escaping (_ dataLoaded: Bool, _ error: Error?) -> Void){
        
        Global.startActivity(view: activityView)
        
        Auth.auth().createUser(withEmail: username, password: password, completion: { (user, error) in
            if error == nil {
                let chosenImage = UIImageJPEGRepresentation(userImage, 0.5)
                Storage.storage().reference().child("profilePhotos").child("\(user!.user.uid).jpg").putData(chosenImage!, metadata: nil, completion: { (metaData, error) in
                    
                    if error == nil {
                        Storage.storage().reference().child("profilePhotos").child("\(user!.user.uid).jpg").downloadURL(completion: { (urlRaw, error) in
                            if let url = urlRaw {
                                let profileImageURLString = url.absoluteString
                                let userDict: [String : Any] = ["username" : username, "password" : password, "location" : location, "profileImageUrl" : profileImageURLString, "questions" : questions]
                                Global.DB_REF_URL.child("Users").child(user!.user.uid).setValue(userDict, withCompletionBlock: { (error, db_ref) in
                                    
                                    if error == nil{
                                        
                                        Auth.auth().signIn(withEmail: user!.user.email!, password: password, completion: { (user, error) in
                                            
                                            if error == nil{
                                                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                                    Global.stopActivity()
                                                    if error == nil
                                                    {
                                                        completion(true, nil)
                                                        print("Image uploaded")
                                                        
                                                    }
                                                    else
                                                    {
                                                        Auth.auth().currentUser?.delete(completion: { (error) in
                                                            if error == nil
                                                            {
                                                                print("User removed")
                                                            }
                                                        })
                                                        
                                                        completion(false, error)
                                                        
                                                        print("Error on sending email: \(error?.localizedDescription ?? "Error occured")")
                                                    }
                                                })
                                            }
                                        })
                                    }
                                    else
                                    {
                                        completion(false, error)
                                        print("Error uploading image \(String(describing: error?.localizedDescription))")
                                        
                                    }
                                })
                            }
                        })
                    }
                    else
                    {
                        completion(false, error)
                        Global.stopActivity()
                        print("Error uploading to storage \(String(describing: error?.localizedDescription))")
                        
                    }
                })
            }
            else
            {
                completion(false, error)
                print("Error on creating: \(String(describing: error))")
            }
        })
    }
}
