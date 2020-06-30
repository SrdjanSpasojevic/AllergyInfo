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
//    var dayDescription: String?
    var iconType: String?
    var date: String?
    var tempMax: Double?
    var tempMin: Double?
    var rainTotalMm: Double?
    
    init(dict: [String : Any]) {
//        self.dayDescription = dict[dayDescriptionKey] as? String
        self.iconType = "chancerain"
        
        self.date = dict["date"] as? String
        self.tempMin = dict["temp_min_c"] as? Double
        self.tempMax = dict["temp_max_c"] as? Double
        self.rainTotalMm = dict["rain_total_mm"] as? Double
        
        if let rainT = self.rainTotalMm,
            rainT < 10.0 {
            weatherType = .good
        } else {
            weatherType = .bad
        }
    }
}
