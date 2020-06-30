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
// weather API:
// date: String


struct WeatherData {

    var weatherType: WeatherType = .none
    var dayDescription: String!
    var iconType: String?
    var date: String!
    var tempMax: Double!
    var tempMin: Double!
    var rainTotalMm: Double!
    
    init(dict: [String : Any]) {
        self.date = dict["date"] as? String
        self.tempMin = dict["temp_min_c"] as? Double
        self.tempMax = dict["temp_max_c"] as? Double
        self.rainTotalMm = dict["rain_total_mm"] as? Double
        
        if self.rainTotalMm == 0.0 {
            weatherType = .good
            self.iconType = "clear"
            self.dayDescription = "Weather is fine today you should not be worried about allergy."
        } else if self.rainTotalMm < 10.0 {
            weatherType = .normal
            self.iconType = "chancerain"
            self.dayDescription = "Weather is fine today but you should consider rainy periods of the day, take caution."
        } else {
            weatherType = .bad
            self.iconType = "rain"
            self.dayDescription = "Weather is bad today you shoul be worried about allergy."
        }
    }
}
