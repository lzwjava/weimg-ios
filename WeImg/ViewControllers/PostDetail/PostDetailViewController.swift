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
    
    var post: Post?
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.registerNib(UINib(nibName: postTitleViewIdentifier, bundle: nil), forCellReuseIdentifier: postTitleViewIdentifier)
        imageTableView.registerNib(UINib(nibName: postImageCellIdentifier, bundle: nil), forCellReuseIdentifier: postImageCellIdentifier)
        fetchData()
    }
    
    func fetchData() {
        PostManager.manager.getPost(post!.postId) { (post: Post?, error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.post = post
                self.imageTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let images = post?.images {
            let cell = tableView.dequeueReusableCellWithIdentifier(postImageCellIdentifier) as! PostImageCell
            let image = images[indexPath.row]
            cell.postImage = image
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let images = post?.images {
            return images.count
        }
        return 0
    }
    
    private func heightForImage(image: Image) -> CGFloat {
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        return width / CGFloat(image.width) * CGFloat(image.height)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let images = post?.images {
            let image = images[indexPath.row]
            return heightForImage(image)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            let postTitleView = tableView.dequeueReusableCellWithIdentifier(postTitleViewIdentifier) as! PostTitleView
            postTitleView.post = post
            return postTitleView
        }
        return UIView()
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
