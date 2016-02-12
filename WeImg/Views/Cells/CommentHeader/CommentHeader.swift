//
//  CommentHeader.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentHeader: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    
    var commentCount: Int? {
        didSet {
            countLabel.text = String(self.commentCount)
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
