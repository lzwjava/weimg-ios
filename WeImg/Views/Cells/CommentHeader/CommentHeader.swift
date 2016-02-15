//
//  CommentHeader.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentHeader: UITableViewCell {
    
    var optionsButton: OptionsButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let optionsButton = OptionsButton.instanceFromNib()
        self.optionsButton = optionsButton
        addSubview(optionsButton)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func heightForPost(post: Post?) -> CGFloat {
        return 44
    }

}
