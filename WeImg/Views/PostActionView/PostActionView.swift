//
//  PostActionView.swift
//  WeImg
//
//  Created by lzw on 16/2/15.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class PostActionView: UIView {
    
    @IBOutlet weak var upVoteView: UIImageView!
    
    @IBOutlet weak var downVoteView: UIImageView!
    
    @IBOutlet weak var shareView: UIImageView!
    
    private var upVoteTap: UITapGestureRecognizer?
    private var downVoteTap: UITapGestureRecognizer?
    
    var vote: String? {
        didSet {
            updateViews()
        }
    }
    
    var upVoteAction: ((vote: String?) -> Void)?
    var downVoteAction: ((vote: String?) -> Void)?
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clearColor()
        
        upVoteTap = UITapGestureRecognizer(target:self, action:  "upVoteClicked:")
        downVoteTap =  UITapGestureRecognizer(target: self, action: "downVoteClicked:")
        upVoteView.addGestureRecognizer(upVoteTap!)
        upVoteView.userInteractionEnabled = true
        downVoteView.addGestureRecognizer(downVoteTap!)
        downVoteView.userInteractionEnabled = true
    }
    
    deinit {
        if let upVoteTap = upVoteTap {
            upVoteView.removeGestureRecognizer(upVoteTap)
        }
        if let downVoteTap = downVoteTap {
            downVoteView.removeGestureRecognizer(downVoteTap)
        }
    }
    
    func upVoteClicked(sender:AnyObject) {
        updateViews()
        upVoteAction?(vote: vote)
    }
    
    private func updateViews() {
        if vote == "up" {
            upVoteView.highlighted = true
            downVoteView.highlighted = false
        } else if vote == "down" {
            upVoteView.highlighted = false
            downVoteView.highlighted = true
        } else {
            upVoteView.highlighted = false
            downVoteView.highlighted = false
        }
    }
    
    func downVoteClicked(sender: AnyObject) {
        updateViews()
        downVoteAction?(vote:vote)
    }
    
    class func instanceFromNib() -> PostActionView {
        return UINib(nibName: "PostActionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PostActionView
    }

}
