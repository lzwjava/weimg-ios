//
//  PostDetailViewController.swift
//  WeImg
//
//  Created by lzw on 16/2/9.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class PostDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let postTitleViewIdentifier = "PostTitleView"
    private let postImageCellIdentifier = "PostImageCell"
    private let commentCellIdentifier = "CommentCell"
    private let commentHeaderIdentifier = "CommentHeader"
    
    var post: Post?
    var comments = [Comment]()
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }
    
    private func setupTableView() {
        imageTableView.registerNib(UINib(nibName: postTitleViewIdentifier, bundle: nil), forCellReuseIdentifier: postTitleViewIdentifier)
        imageTableView.registerNib(UINib(nibName: postImageCellIdentifier, bundle: nil), forCellReuseIdentifier: postImageCellIdentifier)
        imageTableView.registerNib(UINib(nibName: commentCellIdentifier, bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        imageTableView.registerNib(UINib(nibName: commentHeaderIdentifier, bundle: nil), forCellReuseIdentifier: commentHeaderIdentifier)
        imageTableView.backgroundColor = UIColor.yepMainColor()
        imageTableView.separatorStyle = .None
    }
    
    private func fetchData() {
        PostManager.manager.getPost(post!.postId) { (post: Post?, error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.post = post
                self.imageTableView.reloadData()
            }
        }
        CommentManager.manager.getComments(post!.postId, skip: 0, limit: 100) { (comments: [Comment], error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.comments = comments
                self.imageTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(postImageCellIdentifier, forIndexPath: indexPath) as! PostImageCell
            configCell(cell, indexPath: indexPath)
            return cell
        case 1:
            let comment = comments[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier) as! CommentCell
            cell.comment = comment
            return cell
        default:
            break;
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            if let images = post?.images {
                return images.count
            } else {
                return 0
            }
        case 1:
            return comments.count
        default:
            return 0
        }
    }
    
    private func configCell(cell: PostImageCell, indexPath: NSIndexPath) {
        if let images = post?.images {
            let image = images[indexPath.row]
            cell.postImage = image
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section) {
        case 0:
            return tableView.fd_heightForCellWithIdentifier(postImageCellIdentifier, configuration: { (cell: AnyObject!) -> Void in
                self.configCell(cell as! PostImageCell, indexPath: indexPath)
            })
        case 1:
            return 20
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(section) {
        case 0:
            let postTitleView = tableView.dequeueReusableCellWithIdentifier(postTitleViewIdentifier) as! PostTitleView
            postTitleView.post = post
            return postTitleView
        case 1:
            let commentHeader = tableView.dequeueReusableCellWithIdentifier(commentHeaderIdentifier) as! CommentHeader
            setupCommentHeader(commentHeader)
            return commentHeader
        default:
            return UIView()
        }
    }
    
    private func setupCommentHeader(header: CommentHeader) {
        var options = [String]()
        options.append("热门评论")
        options.append("最新评论")
        header.optionsButton?.options = options
        header.optionsButton?.selectAction = {[weak self] selectedIndex in
            if let strongSelf = self {
                strongSelf.loadCommentsByOrder(selectedIndex)
            }
        }
    }
    
    private func loadCommentsByOrder(type: Int) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(section) {
        case 0:
            return PostTitleView.heightForPost(post)
        case 1:
            return CommentHeader.heightForPost(post)
        default:
            break
        }
        return 0
    }
    
    
    
    @IBAction func upButtonClicked(sender: AnyObject) {
        PostManager.manager.vote(post!.postId, vote: "up") { (error: NSError?) -> Void in
            if self.filterError(error) {
                println("succeed")
            }
        }
    }

    @IBAction func downButtonClicked(sender: AnyObject) {
        PostManager.manager.vote(post!.postId, vote: "down") { (error: NSError?) -> Void in
            if self.filterError(error) {
                println("succeed")
            }
        }
    }
    
}