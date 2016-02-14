//
//  CustomDateTransform.swift
//  WeImg
//
//  Created by lzw on 16/2/14.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

public class CustomDateTransform : DateFormatterTransform {
    
    public init() {
        let formatter = NSDateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: "zh_CN_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        super.init(dateFormatter: formatter)
    }
    
}