//
//  Global.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 9/6/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseDatabase

class AIAppState: NSObject {
    static let sharedInstance = AIAppState()
    
    var dataSource = [WeatherData]()
    
    func fetchData(){
        let first = WeatherData(dayDescription: "It is rainy day outside, don't worry about the allergy")
        let second = WeatherData(dayDescription: "It is a hot day outside, be carefull today, high allergy alert!")
        let third = WeatherData(dayDescription: "It is a hot day outside, it's safe today, but beware")
        let fourth = WeatherData(dayDescription: "It is rainy day outside, don't worry about the allergy")
        let fifth = WeatherData(dayDescription: "It is a hot day outside, be carefull today, high allergy alert!")
        let sixth = WeatherData(dayDescription: "It is a hot day outside, it's safe today, but beware")
        let seventh = WeatherData(dayDescription: "It is rainy day outside, don't worry about the allergy")
        
        AIAppState.sharedInstance.dataSource.append(first)
        AIAppState.sharedInstance.dataSource.append(second)
        AIAppState.sharedInstance.dataSource.append(third)
        AIAppState.sharedInstance.dataSource.append(fourth)
        AIAppState.sharedInstance.dataSource.append(fifth)
        AIAppState.sharedInstance.dataSource.append(sixth)
        AIAppState.sharedInstance.dataSource.append(seventh)
    }
}
