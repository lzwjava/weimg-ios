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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionLabelHeight: NSLayoutConstraint!
    
    var postImage:Image? {
        didSet {
            if let postImage = postImage {
                postImageView.kf_setImageWithURL(NSURL(string: postImage.link)!)
                
                let imageHeight = round(postImageView.frame.width / CGFloat(postImage.width) * CGFloat(postImage.height))
                imageHeightConstraint.constant = imageHeight
                
                if let desc = postImage.description {
                    descriptionLabel.text = desc
                    descriptionLabelHeight.active = false
                } else {
                    descriptionLabelHeight.active = true
                    descriptionLabelHeight.constant = 0
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        postImageView.image = nil
        descriptionLabel.text = nil
        
        selectionStyle = .None
    }
    
//    class func heightForImage(image: Image, width: CGFloat) -> CGFloat {
//        return width / CGFloat(image.width) * CGFloat(image.height)
//    }
    
}
