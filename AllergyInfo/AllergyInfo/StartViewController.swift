//
//  ViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 3/22/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import SideMenuController


class StartViewController: SideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu_icon")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = UIScreen.main.bounds.width - 100
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        
        //performSegue(withIdentifier: "showLoginController", sender: nil)
        performSegue(withIdentifier: "showCenterController1", sender: nil)
//        performSegue(withIdentifier: "showCenterController2", sender: nil)
//        performSegue(withIdentifier: "showCenterController3", sender: nil)
//        performSegue(withIdentifier: "showCenterController4", sender: nil)
//        performSegue(withIdentifier: "showCenterController5", sender: nil)
        
        performSegue(withIdentifier: "containSideMenu", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning")
    }
}
