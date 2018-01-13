//
//  CurrentInfoViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/26/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class CurrentInfoViewController: UIViewController {

    @IBOutlet weak var backgroundHolderView: UIView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    var dataObject: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundHolderView.roundCorners(cornerRadius: 15)
        self.backgroundHolderView.addDropShadow(color: UIColor.black, opacity: 1.0, offSet: CGSize(width: 1, height: 1), radius: 10, scale: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dataObject = self.dataObject{
            self.navigationItem.title = dataObject.date
            if let icon = dataObject.iconType{
                self.weatherIcon.image = UIImage(named: icon)
            }
            self.todayLabel.text = dataObject.dayDescription
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
