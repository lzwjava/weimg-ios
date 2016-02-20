//
//  CommentHeader.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentHeader: UITableViewCell {
    
    var optionsButton =  OptionsButton.instanceFromNib()
    
    @IBOutlet weak var commentButton: UIButton!
    
    var commentAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(optionsButton)
        
        commentButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        commentButton.titleLabel!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        commentButton.imageView!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func heightForPost(post: Post?) -> CGFloat {
        return 44
    }

    @IBAction func commentButtonClicked(sender: AnyObject) {
        commentAction?()
    }
}
