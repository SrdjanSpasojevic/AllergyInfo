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

    let segues = ["showCenterController1", "showCenterController3", "showCenterController4", "logOutSegue"]
    let controllerNames = ["Home", "Settings", "About", "Log out"]
    var selectedIndexPath : IndexPath?
    
    
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfilePhoto.layer.masksToBounds = true
        self.userProfilePhoto.layer.cornerRadius = self.userProfilePhoto.bounds.size.height / 2
        self.userProfilePhoto.layer.borderWidth = 3.0
        self.userProfilePhoto.layer.borderColor = ColorsPallete.navigationBarLabelColor.cgColor
        
        self.view.backgroundColor = ColorsPallete.navigationBarColor
        
        self.selectedIndexPath = IndexPath(row: 0, section: 0)
        
        let userID = Auth.auth().currentUser?.uid
        Global.DB_REF_URL.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllerNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3
        {
            self.singOutUser()
            return
        }
        
        if self.selectedIndexPath != nil
        {
            if self.selectedIndexPath?.row != indexPath.row
            {
                self.sideMenuController?.performSegue(withIdentifier: self.segues[indexPath.row], sender: nil)
                self.selectedIndexPath = indexPath
            }
            else
            {
                self.sideMenuController?.toggle()
            }
        }
        
    }
    
    private func singOutUser(){
        //MARK: Not sure this works
        
        let alertVC = UIAlertController(title: nil, message: "Are you sure you want to Log out?", preferredStyle: .actionSheet)
        
        let actionYES = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            Global.deleteDictionaryFromDisk(withKey: "loggedInUser") { (finishedWithSuccess) in
                if finishedWithSuccess
                {
                    try? Auth.auth().signOut()
                    LocalNotificationManager.engine.setIsNotificationSeen()
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
                    loginVC?.modalPresentationStyle = .fullScreen
                    self.present(loginVC!, animated: true, completion: nil)
                }
                else
                {
                    Global.displayClassicAlert(message: "There is an error with sing out\nPlease try later", viewController: self)
                }
            }
            
        }
        
        let actionNO = UIAlertAction(title: "No", style: .destructive) { (action) in
            
            alertVC.dismiss(animated: true, completion: nil)
            
        }
        
        alertVC.addAction(actionYES)
        alertVC.addAction(actionNO)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
        
        // animation is too slow
        //self.view.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell") as! MenuTableViewCell
        
        cell.controllerLabel.text = self.controllerNames[indexPath.row]
        cell.controllerLabel.layer.cornerRadius = 20
        cell.controllerLabel.clipsToBounds = true
        
        return cell
    }
}
