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
    private let commentSelectionCellIdentifier = "CommentSelectionCell"
    
    var post: Post!
    var comments = [Comment]()
    var postActionView: PostActionView?
    var postTitleView: PostTitleView?
    
    struct Arrange {
        var type = 0
        var index = 0
    }
    
    private var arranges = [Arrange]()
    var commentSelections = Set<Int>()
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        updateArranges()
        fetchData()
        setupNavigationBar()
    }
    
    private func updateArranges() {
        arranges.removeAll()
        guard comments.count > 0 else {
            return
        }
        var cellCount = 0
        var commentCount = 0
        var selectionCount = 0
        for i in 0...(comments.count-1) {
            var commentArrange = Arrange()
            commentArrange.type = 0
            commentArrange.index = commentCount
            commentCount++
            cellCount++
            arranges.append(commentArrange)
            if commentSelections.contains(i) {
                var selectionArrange = Arrange()
                selectionArrange.type = 1
                selectionArrange.index = i
                selectionCount++
                cellCount++
                arranges.append(selectionArrange)
            }
        }
        assert(commentCount == comments.count)
        assert(selectionCount == commentSelections.count)
        assert(commentCount + selectionCount == cellCount)
    }
    
    private func vote(vote: String, origin: String?) {
        PostManager.manager.vote(post.postId, vote: vote) { (voteItem: VoteItem?, error: NSError?) -> Void in
            if self.filterError(error) {
                self.fetchPost()
            }
        }
    }
    
    func setupNavigationBar() {
        let actionView = PostActionView.instanceFromNib()
        actionView.upVoteAction = { (vote: String?) -> Void in
            self.vote("up", origin: vote)
        }
        actionView.downVoteAction = {(vote: String?) -> Void in
            self.vote("down", origin: vote)
        }
        self.postActionView = actionView
        navigationItem.titleView = actionView
    }
    
    private func setupTableView() {
        imageTableView.registerNib(UINib(nibName: postTitleViewIdentifier, bundle: nil), forCellReuseIdentifier: postTitleViewIdentifier)
        imageTableView.registerNib(UINib(nibName: postImageCellIdentifier, bundle: nil), forCellReuseIdentifier: postImageCellIdentifier)
        imageTableView.registerNib(UINib(nibName: commentCellIdentifier, bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        imageTableView.registerNib(UINib(nibName: commentHeaderIdentifier, bundle: nil), forCellReuseIdentifier: commentHeaderIdentifier)
        imageTableView.registerNib(UINib(nibName: commentSelectionCellIdentifier, bundle: nil), forCellReuseIdentifier: commentSelectionCellIdentifier)
        
        imageTableView.backgroundColor = UIColor.yepMainColor()
        imageTableView.separatorStyle = .SingleLine
        imageTableView.separatorColor = UIColor.yepMainColor()
    }
    
    private func fetchPost() {
        PostManager.manager.getPost(post!.postId) { (post: Post?, error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.post = post!
                self.postActionView?.vote = post!.vote
                self.imageTableView.reloadData()
            }
        }
    }
    
    func fetchComments() {
        CommentManager.manager.getComments(post!.postId, skip: 0, limit: 100) { (comments: [Comment], error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.comments = comments
                self.updateArranges()
                self.imageTableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        fetchPost()
        fetchComments()
    }
    
    private func voteCommentAtIndex(index: Int, vote: String) {
        let comment = self.comments[index]
        CommentManager.manager.voteComment(self.post.postId, commentId: comment.commentId, vote: vote, completion: { (error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.fetchComments()
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(postImageCellIdentifier, forIndexPath: indexPath) as! PostImageCell
            configCell(cell, indexPath: indexPath)
            return cell
        case 1:
            let arrange = arranges[indexPath.row]
            if arrange.type == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier) as! CommentCell
                configCommentCell(cell, indexPath: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(commentSelectionCellIdentifier) as! CommentSelectionCell
                cell.commentIndex = arrange.index
                cell.upvoteAction = { (commentIndex: Int) in
                    self.voteCommentAtIndex(commentIndex, vote: "up")
                }
                cell.downvoteAction = { (commentIndex: Int) in
                    self.voteCommentAtIndex(commentIndex, vote: "down")
                }
                return cell
            }
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
            if let images = post.images {
                return images.count
            } else {
                return 0
            }
        case 1:
            return arranges.count
        default:
            return 0
        }
    }
    
    private func configCell(cell: PostImageCell, indexPath: NSIndexPath) {
        if let images = post.images {
            let image = images[indexPath.row]
            cell.postImage = image
        }
    }
    
    private func configCommentCell(cell: CommentCell, indexPath: NSIndexPath) {
        let arrange = arranges[indexPath.row]
        let comment = comments[arrange.index]
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
            let arrange = arranges[indexPath.row]
            if arrange.type == 0 {
                let height = tableView.fd_heightForCellWithIdentifier(commentCellIdentifier, configuration: { (cell: AnyObject!) -> Void in
                    self.configCommentCell(cell as! CommentCell, indexPath: indexPath)
                })
                return height
            } else {
                return 44
            }
        default:
            return 0
        }
    }
    
    private func wrapCellAsView(cell: UITableViewCell) -> UIView {
        let view = UIView()
        let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, cell.bounds.height)
        cell.frame = frame
        view.frame = frame
        view.addSubview(cell)
        return view
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(section) {
        case 0:
            let postTitleView = tableView.dequeueReusableCellWithIdentifier(postTitleViewIdentifier) as! PostTitleView
            postTitleView.post = post
            self.postTitleView = postTitleView
            return wrapCellAsView(postTitleView)
        case 1:
            let commentHeader = tableView.dequeueReusableCellWithIdentifier(commentHeaderIdentifier) as! CommentHeader
            setupCommentHeader(commentHeader)
            return wrapCellAsView(commentHeader)
        default:
            return UIView()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
        case 0:
            break;
        case 1:
            let arrange = arranges[indexPath.row]
            if arrange.type == 0 {
                if (commentSelections.contains(arrange.index)) {
                    commentSelections.remove(arrange.index)
                    arranges.removeAtIndex(indexPath.row + 1)
//                    updateArranges()
                    let newIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                    imageTableView.deleteRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
                } else {
                    commentSelections.insert(arrange.index)
                    var newArrange = Arrange()
                    newArrange.type = 1
                    newArrange.index = arrange.index
                    arranges.insert(newArrange, atIndex: indexPath.row + 1)
//                    updateArranges()
                    let newIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                    imageTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
                }
//                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
            break;
        default:
            break;
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func setupCommentHeader(header: CommentHeader) {
        var options = [String]()
        options.append("热门评论")
        options.append("最新评论")
        header.optionsButton.options = options
        header.optionsButton.selectAction = {[weak self] selectedIndex in
            if let strongSelf = self {
                strongSelf.loadCommentsByOrder(selectedIndex)
            }
        }
        
        header.commentAction = { [weak self] in
            if let strongSelf = self {
                strongSelf.performSegueWithIdentifier("showComment", sender: strongSelf.post)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier != nil else {
            return
        }
        if segue.identifier == "showComment" {
            let vc = segue.destinationViewController as! CommentViewController
            vc.post = sender as! Post
            vc.postDetailViewController = self
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
