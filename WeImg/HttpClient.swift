//
//  HttpClient.swift
//  WeImg
//
//  Created by lzw on 16/1/31.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import Alamofire

class HttpClient {
    
    private static var baseUrl : String = "http://localhost:3005/";
    
    static func get(URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil)
        -> Request
    {
        let url = baseUrl + URLString.URLString;
        return Alamofire.request(.GET, url, parameters: parameters)
    }
    
    static func get(URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil, completion:(AnyObject?, NSError?) -> Void){
        let url = baseUrl + URLString.URLString;
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { (resp: Response<AnyObject, NSError>) -> Void in
            if let error = errorFromReponse(resp) {
                completion(nil, error)
            } else {
                completion(resultFromReponse(resp), nil)
            }
        }
    }
    
    private static func errorFromReponse(resp: Response<AnyObject, NSError>) -> NSError? {
        if resp.result.error != nil {
            return resp.result.error
        } else {
            let dict = resp.result.value as! [String: AnyObject]
            let status = dict["status"] as! String
            if status != "success" {
                var userInfo = [NSObject: AnyObject]()
                userInfo[NSLocalizedDescriptionKey] = dict["error"] as! String
                let statusError = NSError(domain: "WeImg", code: 0, userInfo: userInfo)
                return statusError
            } else {
                return nil;
            }
        }
    }
    
    private static func resultFromReponse(resp: Response<AnyObject, NSError>) -> AnyObject? {
        let dict = resp.result.value as! [String: AnyObject]
        return dict["result"]
    }
    
    static func post(URLString: URLStringConvertible,
        parameters: [String: AnyObject], completionHandler: ([String: AnyObject]?,NSError?) -> Void) {
        let url = baseUrl + URLString.URLString
            Alamofire.request(.POST, url, parameters: parameters).responseJSON() { (resp: Response<AnyObject, NSError>) in
                if let error = errorFromReponse(resp) {
                    completionHandler(nil, error)
                } else {
                    let result = resultFromReponse(resp)
                    completionHandler(result as? [String:AnyObject], nil)
                }
            }
    }
    
    static func post(URLString: URLStringConvertible,
        parameters: [String: AnyObject], completionHandler: (NSError?) -> Void) {
            post(URLString, parameters: parameters) { (dict: [String: AnyObject]?, error: NSError?) -> Void in
                completionHandler(error)
            }
    }
    
}