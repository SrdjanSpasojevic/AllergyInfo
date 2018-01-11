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
    var dataLoaded = false
    
    func fetchData(completion: @escaping (_ dataLoaded: Bool) -> Void){
        Global.DB_REF_URL.child(dataKey).observe(.value, with: { snapshot in
            if snapshot.exists(){
                guard let dict = snapshot.value! as? NSDictionary else {
                    completion(false)
                    return
                }
                
                self.dataSource.append(WeatherData.init(dict: dict[dayOneKey] as! NSDictionary))
                self.dataSource.append(WeatherData.init(dict: dict[dayTwoKey] as! NSDictionary))
                self.dataSource.append(WeatherData.init(dict: dict[dayThreeKey] as! NSDictionary))
                self.dataSource.append(WeatherData.init(dict: dict[dayFour] as! NSDictionary))
                
                if self.dataSource.isEmpty{
                    completion(false)
                }else{
                    completion(true)
                }
            }else{
                completion(false)
            }
            
        })
        
        
        
    }
}
