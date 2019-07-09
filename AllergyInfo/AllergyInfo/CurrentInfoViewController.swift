//
//  CurrentInfoViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/26/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class CurrentInfoViewController: UIViewController {

    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var backgroundHolderView: UIView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    var dataObject: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundHolderView.roundCorners(cornerRadius: 15)
        self.backgroundHolderView.addDropShadow(color: UIColor.black, opacity: 1.0, offSet: CGSize(width: 1, height: 1), radius: 10, scale: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dissmissVC))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.backgroundBlurView.addGestureRecognizer(tapGesture)
        
        LocalNotificationManager.engine.createNotification(title: "High Risk", body: "High risk of allergies today. If you are going out, make sure you have your medications with you.", categoryID: .critical, fireIn: 60)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dataObject = self.dataObject
        {
            self.navigationItem.title = dataObject.date
            
            if let icon = dataObject.iconType
            {
                self.weatherIcon.image = UIImage(named: icon)
            }
            
            self.todayLabel.text = dataObject.dayDescription
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dissmissAction(_ sender: Any)
    {
        self.dissmissVC()
    }
    
    @objc private func dissmissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
