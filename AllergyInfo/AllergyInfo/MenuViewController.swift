//
//  MenuViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/26/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import SideMenuController
import SDWebImage
import Firebase

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let segues = ["showCenterController1", "showCenterController2", "showCenterController3", "showCenterController4", "logOutSegue"]
    let controllerNames = ["Home", "Current info about allergy", "Settings", "About", "Log out"]
    var selectedIndexPath : NSIndexPath?
    
    
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfilePhoto.layer.masksToBounds = true
        self.userProfilePhoto.layer.cornerRadius = self.userProfilePhoto.bounds.size.height / 2
        let userID = FIRAuth.auth()?.currentUser?.uid
        AIAppState.sharedInstance.DB_REF_URL.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Snapshot value: \(snapshot.value!)")
            let userDict = snapshot.value as? NSDictionary
            DispatchQueue.main.async {
                let activity = UIActivityIndicatorView()
                activity.hidesWhenStopped = true
                activity.center = self.userProfilePhoto.center
                self.userProfilePhoto.addSubview(activity)
                activity.startAnimating()
                let userName = userDict?["username"] as! String
                self.userNameLabel.text = userName
                let url = URL(string: userDict?["profileImageUrl"] as! String)
                self.userProfilePhoto.sd_setImage(with: url, completed: { (image, error, cache, url) in
                    activity.stopAnimating()
                })
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllerNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath as NSIndexPath?
        if indexPath.row == 4{
            UserDefaults.standard.removeObject(forKey: "loggedInUser")
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginViewController")
            self.present(loginVC!, animated: true, completion: nil)
        }else{
           sideMenuController?.performSegue(withIdentifier: self.segues[indexPath.row], sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell") as! MenuTableViewCell
        
        cell.controllerLabel.text = self.controllerNames[indexPath.row]
        cell.controllerLabel.layer.cornerRadius = 20
        cell.controllerLabel.clipsToBounds = true
        
        return cell
    }
    
    
    
}
