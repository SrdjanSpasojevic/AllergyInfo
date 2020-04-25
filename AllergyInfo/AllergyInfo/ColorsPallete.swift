//
//  ColorsPallete.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 3/23/18.
//  Copyright © 2018 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import TextFieldEffects

class ColorsPallete: UIColor {
    
    enum Options {
        case backgroundColor
        case titleColor
    }
    
    typealias Map = [EntryPoint : UIColor]
    
    enum EntryPoint {
        case baseColor
        case navigationBarColor
        case navigationBarLabelColor
        case labelTintColor
        case startVCColor
    }
    
    
    private static var colorMap: Map  = [
        .baseColor: UIColor.init(hex: "B3DEC1"),
        .navigationBarColor: UIColor.init(hex: "210124"),
        .navigationBarLabelColor: UIColor.init(hex: "750D37"),
        .labelTintColor: UIColor.init(hex: "FEFFFE"),
        .startVCColor: UIColor.init(hex: "E5FCF5")
    ]
    
    static func setColors(to views: [Any], color: UIColor, withOption option: Options) {

        for view in views {
            
            if option == .titleColor {
                
                if let label = view as? UILabel {
                    
                    label.textColor = color
                    
                } else if let button = view as? UIButton {
                    
                    button.setTitleColor(color, for: .normal)
                    
                } else if let textField = view as? HoshiTextField {
                    
                    textField.textColor = color
                    textField.placeholderColor = color
                    
                }

            } else if option == .backgroundColor {
                
                if let view = view as? UIView {
                    
                    view.backgroundColor = color
                    
                }
                
            }
        }
    }
    
    static var baseColor: UIColor {
        return self.colorMap[.baseColor] ?? .white
    }
    
    static var navigationBarColor: UIColor{
        return self.colorMap[.navigationBarColor] ?? .white
    }
    
    static var navigationBarLabelColor: UIColor {
        return self.colorMap[.navigationBarLabelColor] ?? .white
    }
    
    static var labelTintColor: UIColor {
        return self.colorMap[.labelTintColor] ?? .white
    }
    
    static var startVCColor: UIColor {
        return self.colorMap[.startVCColor] ?? .white
    }
    
    
    
}
