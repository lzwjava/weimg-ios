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
import Photos

class ImageManager : BaseManager {
    static let manager: ImageManager = {
        return ImageManager()
    }()
    
    func getUpload(completionHandler: (UploadToken?, NSError?) -> Void) {
        HttpClient.request(.GET, "files/uptoken", completion: completionHandler)
    }
    
    func uploadImageData(imageData: NSData, completion:([String:String]?, NSError?) -> Void) {
        getUpload { (uploadToken: UploadToken?, error: NSError?) -> Void in
            let upManager = QNUploadManager()
            let key = (uploadToken?.imageId)! + ".jpg"
            upManager.putData(imageData, key: key, token: uploadToken?.uptoken, complete: { (resp: QNResponseInfo!, key: String!, dict: [NSObject : AnyObject]!) -> Void in
                if !resp.ok {
                    completion(nil, resp.error)
                } else {
                    var data = [String: String]()
                    data["url"] = (uploadToken?.bucketUrl)! + "/" + key
                    data["key"] = uploadToken?.imageId
                    completion(data, nil)
                }
            }, option: nil)
        }
    }
    
    func uploadImage(asset: PHAsset, desc: String?, completionHandler:(String?, NSError?) -> Void) {
        let manager = PHImageManager.defaultManager()
        let options = PHImageRequestOptions()
        options.synchronous = true
        options.resizeMode = .None
        manager.requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .Default, options: options) { (image: UIImage?, info: [NSObject : AnyObject]?) -> Void in
            if let image = image {
                let data = UIImageJPEGRepresentation(image, YepConfig.imageCompressionQuality())
                self.uploadImageData(data!) { (dict: [String: String]?, error: NSError?) -> Void in
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    var params = [String: AnyObject]()
                    params["imageId"] = dict!["key"]
                    params["link"] = dict!["url"]
                    if desc != nil {
                        params["description"] = desc
                    }
                    params["width"] = Int(image.size.width)
                    params["height"] = Int(image.size.height)
                    HttpClient.request(.POST, "images", parameters: params) { (error: NSError?) -> Void in
                        if error != nil {
                            completionHandler(nil, error)
                        } else {
                            completionHandler(params["imageId"] as? String, nil)
                        }
                    }
                }
                
            }
        }
//        manager.requestImageDataForAsset(image, options: nil) { (data: NSData?, dataUTI: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) -> Void in
//                   }
    }
}
