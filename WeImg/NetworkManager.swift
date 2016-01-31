//
//  NetworkManager.swift
//  WeImg
//
//  Created by lzw on 16/1/31.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private static var baseUrl : String = "http://localhost:3005/";

    static let manager: NetworkManager = {
        return NetworkManager()
    }()
    
    static func get(URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil)
        -> Request
    {
        let url = baseUrl + URLString.URLString;
        return Alamofire.request(.GET, url, parameters: parameters)
    }
    
}