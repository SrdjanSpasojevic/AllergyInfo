//
//  ViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 3/22/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import SideMenuController
import UserNotifications


class StartViewController: SideMenuController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorsPallete.navigationBarColor
        
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu_icon")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = UIScreen.main.bounds.width - 100
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        SideMenuController.preferences.interaction.menuButtonAccessibilityIdentifier = ""

        
        self.performSegue(withIdentifier: "showCenterController1", sender: nil)
        
        self.performSegue(withIdentifier: "containSideMenu", sender: nil)
        
        if #available(iOS 10.0, *) {
            //Seeking permission of the user to display app notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in })
            UNUserNotificationCenter.current().delegate = self
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        completionHandler()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning")
    }
}
