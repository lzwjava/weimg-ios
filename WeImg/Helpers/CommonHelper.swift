//
//  CommonHelper.swift
//  WeImg
//
//  Created by lzw on 16/2/2.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation


typealias CancelableTask = (cancel: Bool) -> Void

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

func delay(time: NSTimeInterval, work: dispatch_block_t) -> CancelableTask? {
    
    var finalTask: CancelableTask?
    
    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key
            
        } else {
            dispatch_async(dispatch_get_main_queue(), work)
        }
    }
    
    finalTask = cancelableTask
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        if let task = finalTask {
            task(cancel: false)
        }
    }
    
    return finalTask
}


func GoogleAnalyticsTrackView(name: String) {
    
}

func GoogleAnalyticsTrackEvent(action: String, label: String, value: NSNumber) {
    
}

func GoogleAnalyticsTrackSocial(network: String, action: String, target: String) {
    
}
