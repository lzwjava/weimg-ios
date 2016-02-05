//
//  NSFileManager+Yep.swift
//  Yep
//
//  Created by NIX on 15/3/31.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

enum FileExtension: String {
    case JPEG = "jpg"
    case MP4 = "mp4"
    case M4A = "m4a"
    
    var mimeType: String {
        switch self {
        case .JPEG:
            return "image/jpeg"
        case .MP4:
            return "video/mp4"
        case .M4A:
            return "audio/m4a"
        }
    }
}

extension NSFileManager {
    
    class func yepCachesURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
    
    // MARK: Avatar
    
    class func yepAvatarCachesURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let avatarCachesURL = yepCachesURL().URLByAppendingPathComponent("avatar_caches", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(avatarCachesURL, withIntermediateDirectories: true, attributes: nil)
            return avatarCachesURL
        } catch _ {
        }
        
        return nil
    }
    
    class func yepAvatarURLWithName(name: String) -> NSURL? {
        
        if let avatarCachesURL = yepAvatarCachesURL() {
            return avatarCachesURL.URLByAppendingPathComponent("\(name).\(FileExtension.JPEG.rawValue)")
        }
        
        return nil
    }
    
    class func saveAvatarImage(avatarImage: UIImage, withName name: String) -> NSURL? {
        
        if let avatarURL = yepAvatarURLWithName(name) {
            let imageData = UIImageJPEGRepresentation(avatarImage, 0.8)
            if NSFileManager.defaultManager().createFileAtPath(avatarURL.path!, contents: imageData, attributes: nil) {
                return avatarURL
            }
        }
        
        return nil
    }
    
    class func deleteAvatarImageWithName(name: String) {
        if let avatarURL = yepAvatarURLWithName(name) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(avatarURL)
            } catch _ {
            }
        }
    }
    
    // MARK: Clean Caches
    
    class func cleanCachesDirectoryAtURL(cachesDirectoryURL: NSURL) {
        let fileManager = NSFileManager.defaultManager()
        
        if let fileURLs = (try? fileManager.contentsOfDirectoryAtURL(cachesDirectoryURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())) {
            for fileURL in fileURLs {
                do {
                    try fileManager.removeItemAtURL(fileURL)
                } catch _ {
                }
            }
        }
    }
    
    class func cleanAvatarCaches() {
        if let avatarCachesURL = yepAvatarCachesURL() {
            cleanCachesDirectoryAtURL(avatarCachesURL)
        }
    }
}

