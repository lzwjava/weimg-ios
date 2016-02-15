//
//  PostImageCell.swift
//  WeImg
//
//  Created by lzw on 16/2/9.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Kingfisher

class PostImageCell: UITableViewCell {
    
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    var postImage:Image? {
        didSet {
            if let postImage = postImage {
                postImageView.kf_setImageWithURL(NSURL(string: postImage.link)!)
//                imageTitleLabel.text = postImage.
                imageHeightConstraint.constant = PostImageCell.heightForImage(postImage)
                descriptionLabel.text = postImage.description
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageTitleLabel.text = nil
        self.postImageView.image = nil
        self.descriptionLabel.text = nil
    }
    
    class func heightForImage(image: Image) -> CGFloat {
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        return width / CGFloat(image.width) * CGFloat(image.height)
    }
    
}
