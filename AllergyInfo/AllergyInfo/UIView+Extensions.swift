//
//  UIView+Extensions.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 12/17/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

extension UIView{
    
    func roundCorners(cornerRadius: CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func addBlurToView(for type: UIBlurEffectStyle){
        let blurEffect = UIBlurEffect(style: type)
        var blurEffectView : UIVisualEffectView = UIVisualEffectView()
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        self.addSubview(blurEffectView)
    }
    
    func animateCell(cell:UITableViewCell) {
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animate(withDuration: 0.7) {
            view.layer.opacity = 1
        }
    }
}
