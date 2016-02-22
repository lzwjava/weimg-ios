//
//  CommentSelectionCell.swift
//  WeImg
//
//  Created by lzw on 16/2/20.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentSelectionCell: UITableViewCell {
    
    var commentIndex: Int!
    
    var upvoteAction: ((Int) -> Void)?
    var downvoteAction: ((Int)-> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func upvoteClicked(sender: AnyObject) {
        upvoteAction?(commentIndex)
    }
    
    @IBAction func downvoteClicked(sender: AnyObject) {
        downvoteAction?(commentIndex)
    }
    
}
