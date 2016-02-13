//
//  PostOutlineCell.swift
//  CHTWaterfallSwift
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit

class PostOutlineCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var post: Post? {
        didSet {
            self.image.kf_setImageWithURL(NSURL(string: post!.cover.link)!)
            self.titleLabel.text = post!.title
            self.pointsLabel.text = String(post!.points)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func sizeForPost(post: Post) -> CGSize {
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2
        let ratio = CGFloat(post.cover.width) / CGFloat(post.cover.height)
        let imageHeight = width / ratio
        let height = imageHeight + 60
        return CGSize(width: width, height: height)
    }
    
}
