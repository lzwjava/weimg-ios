//
//  UserManager.swift
//  WeImg
//
//  Created by lzw on 16/2/2.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import CryptoSwift

class UserManager: BaseManager {
    var pickedUsername: String?
    var pickedMobilePhoneNumber: String?
    var pickedPassword: String?
    static var currentUser: User?
    
    static let manager: UserManager = {
        return UserManager()
    }()
    
    func login(mobilePhoneNumber: String, password: String, completion: (NSError?) -> Void) {
        let dict: [String: String] = ["mobilePhoneNumber": mobilePhoneNumber,
            "password": password.md5()];
        HttpClient.post("login", parameters:dict) {
            (user: User?, error: NSError?) -> Void in
            guard error == nil else {
                completion(error)
                return
            }
            self.changeUser(user!)
            completion(nil)
        }
    }
    
    func register(mobilePhoneNumber: String, password: String, smsCode: String, username: String, completion: (NSError?) -> Void) {
        HttpClient.post("users", parameters: [
            "mobilePhoneNumber": mobilePhoneNumber,
            "password": password.md5(),
            "smsCode": smsCode,
            "username": username]) {
                (user: User?, error: NSError?) in
                guard error == nil else {
                    completion(error)
                    return
                }
                self.changeUser(user!)
                completion(nil)
        }
    }
    
    func requestSmsCode(mobilePhoneNumber: String, completion:(NSError?) -> Void) {
        HttpClient.post("requestSmsCode", parameters: ["mobilePhoneNumber": mobilePhoneNumber], completionHandler: completion)
    }
    
    func fetchSelf(completion: (User?, NSError?) -> Void) {
        HttpClient.get("users/self", completion:completion)
    }
    
    private func changeUser(user: User) {
        UserManager.currentUser = user
    }
    
    func userWithUserId(userId: String) {
        
    }
}
