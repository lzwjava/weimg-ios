//
//  CommentViewController.swift
//  WeImg
//
//  Created by lzw on 16/2/20.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentViewController: BaseViewController {

    @IBOutlet weak var commentTextView: UITextView!
    var commentAccessoryView = CommentAccessoryView.instanceFromNib()
    var post: Post!
    var postDetailViewController: PostDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentAccessoryView.sendAction = { () in
            let content = self.commentTextView.text
            if !content.isEmpty {
                CommentManager.manager.createComment(content, postId: self.post.postId, parentId: nil, completion: { (error: NSError?) -> Void in
                    if (self.filterError(error)) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.postDetailViewController.fetchComments()
                    }
                })
            }
        }
        commentTextView.inputAccessoryView = commentAccessoryView
        commentTextView.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
