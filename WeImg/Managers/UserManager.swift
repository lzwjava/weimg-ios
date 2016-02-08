//
//  UserManager.swift
//  WeImg
//
//  Created by lzw on 16/2/2.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import CryptoSwift
import ObjectMapper

class UserManager: BaseManager {
    var pickedUsername: String?
    var pickedMobilePhoneNumber: String?
    var pickedPassword: String?
    static var currentUser: User? = {
        let jsonString = NSUserDefaults.standardUserDefaults().objectForKey("currentUser") as? String
        if let jsonString = jsonString {
            let user = Mapper<User>().map(jsonString)
            return user
        } else {
            return nil
        }
    }()
    
    static let manager: UserManager = {
        return UserManager()
    }()
    
    func login(mobilePhoneNumber: String, password: String, completion: (NSError?) -> Void) {
        let dict: [String: String] = ["mobilePhoneNumber": mobilePhoneNumber,
            "password": password.md5()];
        HttpClient.request(.POST, "login", parameters:dict) {
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
        HttpClient.request(.POST, "users", parameters: [
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
        HttpClient.request(.POST, "requestSmsCode", parameters: ["mobilePhoneNumber": mobilePhoneNumber], completion: completion)
    }
    
    func fetchSelf(completion: (User?, NSError?) -> Void) {
        HttpClient.request(.GET, "users/self", completion:completion)
    }
    
    private func changeUser(user: User) {
        UserManager.currentUser = user
        let jsonString = user.toJSONString()
        NSUserDefaults.standardUserDefaults().setObject(jsonString, forKey: "currentUser")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func userWithUserId(userId: String) {
        
    }
    
    private func updateInfo(avatarUrl: String?, username: String?, introduction: String?, completion:(User?, NSError?) -> Void) {
        var params =  [String: AnyObject]()
        if let avatarUrl = avatarUrl {
            params["avatarUrl"] = avatarUrl
        }
        if let username = username {
            params["username"] = username
        }
        if let introduction = introduction {
            params["introduction"] = introduction
        }
        HttpClient.request(.PATCH, "self", parameters: params) { (user: User?, error: NSError?) -> Void in
            guard error == nil else {
                completion(nil, error)
                return
            }
            self.changeUser(user!)
            completion(user!, nil)
        }
    }
    
    func updateAvatarWithImageData(data: NSData, completion:(NSError?) -> Void) {
        ImageManager.manager.uploadImageData(data) { (dict: [String : String]?, error: NSError?) -> Void in
            guard error == nil else {
                completion(error)
                return
            }
            let avatarUrl = dict!["url"]
            self.updateInfo(avatarUrl, username: nil, introduction: nil, completion: { (user: User?, error: NSError?) -> Void in
                completion(error)
            })
        }
    }
    
    func clearCurrentUser() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
