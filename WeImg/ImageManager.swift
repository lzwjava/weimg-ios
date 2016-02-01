//
//  ImageManager.swift
//  WeImg
//
//  Created by lzw on 16/2/1.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import Alamofire

class ImageManager : BaseManager {
    static let manager: ImageManager = {
        return ImageManager()
    }()
    
    func getUpload(completionHandler: (UploadToken?, NSError?) -> Void) {
        NetworkManager.get("images/upload").responseObject("result") { (response: Response<UploadToken, NSError>) in
            if response.result.error != nil {
                completionHandler(nil, response.result.error!);
            } else {
                completionHandler(response.result.value!, nil);
            }
        };
    }
}
