//
//  PostTitleView.swift
//  WeImg
//
//  Created by lzw on 16/2/9.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import DateTools

class PostTitleView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var voteLabel: UILabel!
    
    @IBOutlet weak var voteContainerView: UIStackView!
    
    @IBOutlet weak var voteImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var post: Post? {
        didSet {
            self.titleLabel.text = self.post?.title
            self.nameLabel.text = self.post?.author.username
            let points = (self.post?.points)!
            self.voteLabel.text = String(points)
            self.timeLabel.text = self.post?.created.timeAgoSinceNow()
//            self.timeLabel.text = self.post?.created
            updateViews()
        }
    }
    
    private func updateViews() {
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.duration = 0.5
        anim.values = [NSNumber(float: 1.0), NSNumber(float:1.2), NSNumber(float: 1.0)]
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.voteContainerView.layer.addAnimation(anim, forKey: nil)
//        self.voteImageView.layer.addAnimation(anim, forKey: nil)
//        self.voteLabel.layer.addAnimation(anim, forKey: nil)
        
        if self.post?.vote == "up" {
            self.voteLabel.textColor = UIColor.yepGreen()
            self.voteImageView.image = UIImage(named: "global_meta_upvote_green")
        } else if self.post?.vote == "down" {
            self.voteLabel.textColor = UIColor.yepRed()
            self.voteImageView.image = UIImage(named: "global_meta_upvote_red")
        } else {
            self.voteLabel.textColor = UIColor.yepGray()
            self.voteImageView.image = UIImage(named: "global_meta_upvote")
        }
        
//        UIView.animateWithDuration(0.25, animations: { () -> Void in
////            self.voteContainerView.transform = CGAffineTransformIdentity
//            self.voteContainerView.transform = CGAffineTransformMakeScale(1.2, 1.2)
//        
//            }) { (Bool) -> Void in
//
//            
//                
//                UIView.animateWithDuration(0.25, animations: { () -> Void in
//                    self.voteContainerView.transform = CGAffineTransformIdentity
//                    }, completion: { (Bool) -> Void in
//                        
//                })
//
//            self.voteContainerView.transform = CGAffineTransformIdentity
//        }
    }
    
    override func awakeFromNib() {
        
    }
    
    class func heightForPost(post: Post?) -> CGFloat {
        return 135
    }
    
}
