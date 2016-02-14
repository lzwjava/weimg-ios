//
//  PostManager.swift
//  WeImg
//
//  Created by lzw on 16/1/31.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import Alamofire

class PostManager : BaseManager {
    static let manager: PostManager = {
        return PostManager()
    }()
    
    func getPosts(skip: Int, limit: Int, completionHandler: ([Post], NSError?) -> Void) {
        var params = [String: AnyObject]()
        params["skip"] = skip
        params["limit"] = limit
        HttpClient.requestArray(.GET, "posts", parameters: params, completion: completionHandler)
    }
    
    func createPost(title: String, imageItems:[ImageItem], completionHandler: (NSError?)-> Void) {
        var blockError: NSError?
        var imageIds = [NSString]()
        for imageItem in imageItems {
            let desc = imageItem.desc
            let sema =  dispatch_semaphore_create(0)
            ImageManager.manager.uploadImage(imageItem.asset, desc: desc, completionHandler: { (imageId: String?, error: NSError?) -> Void in
                if error != nil {
                    blockError = error
                } else {
                    imageIds.append(imageId!)
                }
                dispatch_semaphore_signal(sema)
            })
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
            if blockError != nil {
                break;
            }
        }
        guard blockError == nil else {
            completionHandler(blockError)
            return
        }
        var parameters = [String: AnyObject]()
        do {
            let imageIdsStr = try NSJSONSerialization.dataWithJSONObject(imageIds, options:[])
            parameters["imageIds"] = NSString(data: imageIdsStr, encoding: NSUTF8StringEncoding)
        } catch {
            
        }
        parameters["title"] = title
        let sema =  dispatch_semaphore_create(0)
        HttpClient.request(.POST, "posts", parameters: parameters) {
            (error: NSError?) in
            blockError = error
            dispatch_semaphore_signal(sema)
        }
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        completionHandler(blockError)
    }
    
    func getPost(postId: Int, completionHandler: (Post?, NSError?) -> Void) {
        HttpClient.request(.GET, "posts/" + String(postId), parameters: nil, completion: completionHandler)
    }
    
    func vote(postId: Int, vote: String, completion:(NSError?) -> Void) {
        HttpClient.request(.GET, "posts/" + String(postId) + "/vote/" + vote, completion: completion)
    }
    
}
