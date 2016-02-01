//
//  UserManager.swift
//  WeImg
//
//  Created by lzw on 16/2/2.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation

class UserManager: BaseManager {
    func login(mobilePhoneNumber: String, password: String, completion: (NSError?) -> Void) {
        let dict: [String: String] = ["mobilePhoneNumber": mobilePhoneNumber,
            "password": password];
        HttpClient.post("login", parameters:dict, completionHandler: completion)
    }
    
    func register(mobilePhoneNumber: String, password: String, smsCode: String, username: String, completion: (NSError?) -> Void) {
    }
}
