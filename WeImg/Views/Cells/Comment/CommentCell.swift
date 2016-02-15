//
//  CommentCell.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            contentLabel.text = comment?.content
            usernameLabel.text = comment?.author.username
            pointsLabel.text = String(comment!.points)
            timeLabel.text = comment?.created.timeAgoSinceNow()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
