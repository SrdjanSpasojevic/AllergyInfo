//
//  AIProgressHud.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 9/6/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class AIProgressHud: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = (UIApplication.shared.keyWindow?.frame)!
        self.backgroundColor = UIColor.black
        self.alpha = 0
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = (UIApplication.shared.keyWindow?.frame)!
        self.backgroundColor = UIColor.black
        self.alpha = 0
    }
    
    func showHUD() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: AIProgressDuration) {
            self.alpha = CGFloat(0.7)
        }
    }
    
    func hideHUD() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: AIProgressDuration, animations: {
            self.alpha = 0
        }) { (done : Bool) in
            self.removeFromSuperview()
        }
    }

}
