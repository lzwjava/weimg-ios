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
    
    func getPost( completionHandler: ([Post], NSError?) -> Void) {
        HttpClient.get("posts").responseArray("result") { (response: Response<[Post], NSError>) in
            if response.result.error != nil {
                completionHandler([], response.result.error!);
            } else {
                let postArray = response.result.value
                completionHandler(postArray!, nil);
            }
        };
    }
    
    func createPost(title: String, images: [UIImage], descs: [String], completionHandler: (NSError?)-> Void) {
        var blockError: NSError?
        var imageIds = [NSString]()
        for (index, image) in images.enumerate() {
            let desc = descs[index]
            let sema =  dispatch_semaphore_create(0)
            ImageManager.manager.uploadImage(image, desc: desc, completionHandler: { (imageId: String?, error: NSError?) -> Void in
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
        completionHandler(blockError)
    }
}
