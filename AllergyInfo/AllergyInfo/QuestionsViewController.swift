//
//  QuestionsViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 1/27/18.
//  Copyright © 2018 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var tellUsInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yourBackImage = UIImage(named: "ic_arrow_back_white")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: yourBackImage, style: .plain, target: self, action: #selector(backTapped))
        
    }
    
    @objc private func backTapped(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
