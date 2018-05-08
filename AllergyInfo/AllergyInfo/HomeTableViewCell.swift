//
//  HomeTableViewCell.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 12/17/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellBackgroundView.roundCorners(cornerRadius: 8.0)
        self.topView.clipsToBounds = true
        
        self.topView.backgroundColor = ColorsPallete.navigationBarLabelColor
        
        if #available(iOS 10.0, *) {
            
        } else {
            // Fallback on earlier versions
        }
        //self.topView.addBlurToView(for: .light)
        //self.cellBackgroundView.addBlurToView(for: .regular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
