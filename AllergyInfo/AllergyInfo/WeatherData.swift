//
//  WeatherData.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 12/18/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

enum WeatherType {
    case good
    case bad
    case normal
    case none
}

class WeatherData: NSObject {

    var weatherType: WeatherType = .none
    var dayDescription: String?
    var iconType: String?
    var date: String?
    
    init(dict: NSDictionary) {
        self.dayDescription = dict[dayDescriptionKey] as? String
        self.iconType = dict[iconTypeKey] as? String
        self.date = dict[dayDateKey] as? String
        
        if iconType == "rain" {
            weatherType = .bad
        } else if iconType == "chancerain" {
            weatherType = .normal
        } else {
            weatherType = .good
        }
    }
}
