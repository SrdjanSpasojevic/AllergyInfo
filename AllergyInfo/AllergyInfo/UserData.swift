//
//  UserData.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 5/8/18.
//  Copyright © 2018 Srdjan Spasojevic. All rights reserved.
//

import Foundation

class UserData: NSObject
{
    static var shared = UserData()
    
    var profileImage: UIImage?
    var username = ""
    var password = ""
    var location = ""
    var questionsDict: [String : String] = [:]
}
