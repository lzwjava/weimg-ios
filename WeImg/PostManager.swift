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
        NetworkManager.get("posts").responseArray("result") { (response: Response<[Post], NSError>) in
            if response.result.error != nil {
                completionHandler([], response.result.error!);
            } else {
                let postArray = response.result.value
                completionHandler(postArray!, nil);
            }
        };
    }
}
