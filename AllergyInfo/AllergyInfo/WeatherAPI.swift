//
//  WeatherAPI.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 29/06/2020.
//  Copyright © 2020 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import Alamofire

private struct WeatherAPIKeys {
    static let apiKey: String = "a499f6d65fc8dea69067f25f28c9bee8"
    static let appId: String = "f6e9a04c"
    static let belgradeLatLon: (String, String) = ("44.7866", "20.4489")
    static let baseURL: String = "http://api.weatherunlocked.com/api/forecast"
}

struct WeatherAPI {
    
    func retrieveWeatherData(completion: @escaping (_ weatherData: [WeatherData]) -> Void) {
        let weatherRequest = AF.request("\(WeatherAPIKeys.baseURL)/\(WeatherAPIKeys.belgradeLatLon.0),\(WeatherAPIKeys.belgradeLatLon.1)?app_id=\(WeatherAPIKeys.appId)&app_key=\(WeatherAPIKeys.apiKey)")
        var weatherDataArray: [WeatherData] = []
        weatherRequest.responseData { (response) in
            do {
                if let responseData = response.data {
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    if let jsonDataDict = jsonData as? Dictionary<String, Any>,
                        let days = jsonDataDict["Days"] as? Array<Dictionary<String, Any>> {
                        for day in days {
                            let weatherDataDay = WeatherData(dict: day)
                            weatherDataArray.append(weatherDataDay)
                        }
                        completion(weatherDataArray)
                    } else {
                        completion(weatherDataArray)
                    }
                } else {
                    completion(weatherDataArray)
                }
            } catch let myJSONError {
                print(myJSONError)
                completion(weatherDataArray)
            }
        }
    }
    
}
