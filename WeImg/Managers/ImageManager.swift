//
//  ImageManager.swift
//  WeImg
//
//  Created by lzw on 16/2/1.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import Alamofire
import Qiniu

class ImageManager : BaseManager {
    static let manager: ImageManager = {
        return ImageManager()
    }()
    
    func getUpload(completionHandler: (UploadToken?, NSError?) -> Void) {
        HttpClient.get("images/upload", completion: completionHandler)
    }
    
    func uploadImage(image: UIImage, desc: String?, completionHandler:(String?, NSError?) -> Void) {
        getUpload { (uploadToken: UploadToken?, error: NSError?) -> Void in
            let data = UIImageJPEGRepresentation(image, 0.8)
            let upManager = QNUploadManager()
            let key = (uploadToken?.imageId)! + ".jpg"
            upManager.putData(data, key: key, token: uploadToken?.uptoken, complete: { (resp: QNResponseInfo!, key: String!, dict: [NSObject : AnyObject]!) -> Void in
                if !resp.ok {
                    completionHandler(nil, resp.error)
                } else {
                    var data = [String: String]()
                    data["link"] = (uploadToken?.bucketUrl)! + "/" + key
                    data["imageId"] = uploadToken?.imageId
                    if desc != nil {
                        data["description"] = desc
                    }
                    HttpClient.post("images", parameters: data) { (dict: [String : AnyObject]?, error: NSError?) -> Void in
                        if error != nil {
                            completionHandler(nil, error)
                        } else {
                            completionHandler(data["imageId"], nil)
                        }
                    }
                }
            }, option: nil)
        }
    }
}
