//
//  CurrentInfoViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/26/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class CurrentInfoViewController: UIViewController {

    var dataObject: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dataObject = self.dataObject{
            self.navigationItem.title = dataObject.date
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
