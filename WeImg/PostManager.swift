//
//  PostManager.swift
//  WeImg
//
//  Created by lzw on 16/1/31.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class PostManager : BaseManager {
    static let manager: PostManager = {
        return PostManager()
    }()
    
    func getPost() {
        NetworkManager.get("posts").responseArray("data.result", { (response: Response<Post, NSError>) in
            let post = response.result.value
            
        });
    }
}
