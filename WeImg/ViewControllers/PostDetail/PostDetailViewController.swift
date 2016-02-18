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
    var postActionView: PostActionView?
    var postTitleView: PostTitleView?
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
        setupNavigationBar()
    }
    
    private func vote(vote: String) {
        PostManager.manager.vote(self.post!.postId, vote: vote) { (error: NSError?) -> Void in
            if self.filterError(error) {
                self.post?.vote = vote
                self.postTitleView?.post = self.post
            }
        }
    }
    
    func setupNavigationBar() {
        let actionView = PostActionView.instanceFromNib()
        actionView.upVoteAction = { (vote: String?) -> Void in
            self.vote("up")
        }
        actionView.downVoteAction = {(vote: String?) -> Void in
            self.vote("down")
        }
        self.postActionView = actionView
        navigationItem.titleView = actionView
    }
    
    private func setupTableView() {
        imageTableView.registerNib(UINib(nibName: postTitleViewIdentifier, bundle: nil), forCellReuseIdentifier: postTitleViewIdentifier)
        imageTableView.registerNib(UINib(nibName: postImageCellIdentifier, bundle: nil), forCellReuseIdentifier: postImageCellIdentifier)
        imageTableView.registerNib(UINib(nibName: commentCellIdentifier, bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        imageTableView.registerNib(UINib(nibName: commentHeaderIdentifier, bundle: nil), forCellReuseIdentifier: commentHeaderIdentifier)
        imageTableView.backgroundColor = UIColor.yepMainColor()
        imageTableView.separatorStyle = .SingleLine
        imageTableView.separatorColor = UIColor.yepMainColor()
    }
    
    private func fetchPost() {
        PostManager.manager.getPost(post!.postId) { (post: Post?, error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.post = post
                self.postActionView?.vote = post?.vote
            }
        }
    }
    
    private func fetchComments() {
        CommentManager.manager.getComments(post!.postId, skip: 0, limit: 100) { (comments: [Comment], error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.comments = comments
                self.imageTableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        fetchPost()
        fetchComments()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(postImageCellIdentifier, forIndexPath: indexPath) as! PostImageCell
            configCell(cell, indexPath: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier) as! CommentCell
            configCommentCell(cell, indexPath: indexPath)
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
    
    private func configCommentCell(cell: CommentCell, indexPath: NSIndexPath) {
        let comment = comments[indexPath.row]
        cell.comment = comment
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section) {
        case 0:
            let height = tableView.fd_heightForCellWithIdentifier(postImageCellIdentifier, configuration: { (cell: AnyObject!) -> Void in
                self.configCell(cell as! PostImageCell, indexPath: indexPath)
            })
            return height
        case 1:
            let height = tableView.fd_heightForCellWithIdentifier(commentCellIdentifier, configuration: { (cell: AnyObject!) -> Void in
                self.configCommentCell(cell as! CommentCell, indexPath: indexPath)
            })
            return height
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(section) {
        case 0:
            let postTitleView = tableView.dequeueReusableCellWithIdentifier(postTitleViewIdentifier) as! PostTitleView
            postTitleView.post = post
            self.postTitleView = postTitleView
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
    
}
