//
//  MenuViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/26/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import SideMenuController

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let segues = ["showCenterController1", "showCenterController2", "showCenterController3", "showCenterController4", "showCenterController1"]
    let controllerNames = ["Home", "Current info about allergy", "Settings", "About", "Log out"]
    var selectedIndexPath : NSIndexPath?
    
    
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameLabel.text = "Срђан Спасојевић"
        self.userProfilePhoto.layer.masksToBounds = true
        self.userProfilePhoto.layer.cornerRadius = self.userProfilePhoto.bounds.size.height / 2
        
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
        sideMenuController?.performSegue(withIdentifier: self.segues[indexPath.row], sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell") as! MenuTableViewCell
        
        cell.controllerLabel.text = self.controllerNames[indexPath.row]
        
        return cell
    }
    
    
    
}
