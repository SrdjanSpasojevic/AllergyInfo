//
//  WeatherData.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 12/18/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class WeatherData: NSObject {

    var dayDescription: String?
    var iconType: String?
    
    init(dict: NSDictionary) {
        self.dayDescription = dict[dayDescriptionKey] as? String
        self.iconType = dict[iconTypeKey] as? String
    }
}
