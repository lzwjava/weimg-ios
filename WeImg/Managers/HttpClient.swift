//
//  HttpClient.swift
//  WeImg
//
//  Created by lzw on 16/1/31.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class HttpClient {
    
    private static var baseUrl : String = "http://localhost:3005/";
    
    private static func request(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, completion:(AnyObject?, NSError?) -> Void) {
        let url = baseUrl + URLString.URLString
        var headers = [String: String]()
        if UserManager.currentUser != nil {
            headers["X-Session"] = UserManager.currentUser?.sessionToken
        }
        Alamofire.request(method, url, parameters: parameters, encoding: .URL, headers: headers).responseJSON { (resp: Response<AnyObject, NSError>) -> Void in
            if let error = errorFromReponse(resp) {
                completion(nil, error)
            } else {
                completion(resultFromReponse(resp), nil)
            }
        }
    }
    
    private static func objectMapperError() -> NSError {
        let failureReason = "ObjectMapper failed to serialize response."
        let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
        return error
    }
    
    private static func request<T: Mappable>(method: Alamofire.Method, _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil, array: Bool, completion:(T?, [T], NSError?) -> Void) {
            request(method, URLString, parameters: parameters) { (result: AnyObject?, error: NSError?) -> Void in
                guard error == nil else {
                    completion(nil, [], error)
                    return
                }
                var parsedObject : T?
                var parsedArray: [T]?
                if array {
                    parsedArray = Mapper<T>().mapArray(result)
                } else {
                    parsedObject = Mapper<T>().map(result)
                }
                guard parsedObject != nil else {
                    completion(nil, [], objectMapperError())
                    return
                }
                if array {
                    completion(nil, parsedArray!, nil)
                } else {
                    completion(parsedObject, [], nil)
                }
            }
    }
    
    static func request<T: Mappable>(method: Alamofire.Method, _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil, completion:(T?, NSError?) -> Void) {
            request(method, URLString, parameters: parameters, array: false) { (object: T?, array: [T]?, error: NSError?) -> Void in
                completion(object, error)
            }
    }
    
    static func request(method: Alamofire.Method, _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil, completion:(NSError?) -> Void) {
            request(method, URLString, parameters: parameters) {
                (object: EmptyObject?, error: NSError?) in
                completion(error)
            }
    }
    
    

    static func requestArray<T: Mappable>(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, completion:([T], NSError?) -> Void) {
            request(method, URLString, parameters: parameters, array: true) { (object: T?, array: [T], error: NSError?) -> Void in
                completion(array, error)
            }
    }

    
    private static func errorFromReponse(resp: Response<AnyObject, NSError>) -> NSError? {
        if resp.result.error != nil {
            return resp.result.error
        } else {
            let dict = resp.result.value as! [String: AnyObject]
            let status = dict["status"] as! String
            if status != "success" {
                var errorInfo = ""
                if dict["error"] != nil {
                    errorInfo = dict["error"] as! String
                } else {
                    errorInfo = status
                }
                let userInfo = [NSLocalizedDescriptionKey: errorInfo]
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
    
}