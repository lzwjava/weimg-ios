//
//  ViewController.swift
//  CHTWaterfallSwift
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit
import Kingfisher

class PostsViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()
    private var posts = [Post]()
    private var optionsButton: OptionsButton?
    private var navigationBarView = PostsNavigationBarView.instanceFromNib()
    
    private var sort = Sort.score
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Attach datasource and delegate
        self.collectionView.dataSource  = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        setupNavigationBar()
        
        //Layout setup
        setupCollectionView()
        
        //Register nibs
        registerNibs()
        
        refreshPosts()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupNavigationBar() {
        let frame = navigationController!.navigationBar.frame
        navigationBarView.setUpWithNavigationFrame(frame)
        navigationItem.titleView = navigationBarView
        
        var options = [String]()
        options.append("最热")
        options.append("最新")
        navigationBarView.optionsButton.options = options
        navigationBarView.optionsButton.selectAction =
            {[weak self] (selectedIndex: Int) in
            if let strongSelf = self {
                if (selectedIndex == 0) {
                    strongSelf.sort = Sort.score
                } else {
                    strongSelf.sort = Sort.created
                }
                strongSelf.refreshPosts()
            }
        }
    }
    
    private func refreshPosts() {
        if !refreshControl.refreshing {
            refreshControl.beginRefreshing()
            collectionView.setContentOffset(CGPointMake(0, -self.refreshControl.frame.size.height), animated: true)
        }
        
        PostManager.manager.refresh { (fetchedPosts: [Post], error: NSError?) -> Void in
            self.refreshControl.endRefreshing()
            if (self.filterError(error)) {
                self.posts = fetchedPosts
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadPosts() {
        PostManager.manager.loadNextPage { (fetchedPosts: [Post], error: NSError?) -> Void in
            if (self.filterError(error)) {
                self.posts.appendContentsOf(fetchedPosts)
                self.collectionView.infiniteScrollingView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CollectionView UI Setup
    func setupCollectionView() {
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = YepConfig.Posts.columnSpacing
        layout.minimumInteritemSpacing = 1.0
        
        // Collection view attributes
        self.collectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView.collectionViewLayout = layout
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(PostsViewController.refresh(_:)), forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
        
        self.collectionView.addInfiniteScrollingWithActionHandler {
            print("load more")
            self.loadPosts()
        }
    }
    
    func refresh(sender: AnyObject) {
        refreshPosts()
    }
    
    // Register CollectionView Nibs
    func registerNibs(){
        
        // attach the UI nib file for the PostOutlineCell to the collectionview 
        let viewNib = UINib(nibName: "PostOutlineCell", bundle: nil)
        collectionView.registerNib(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
            case "showPostDetail":
                let vc = segue.destinationViewController as! PostDetailViewController
                vc.post = sender as? Post
                break
            default:
                break
        }
    }
}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout
{
    //MARK: - CollectionView Delegate Methods
    
    //** Number of Cells in the CollectionView */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //** Create a basic CollectionView Cell */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PostOutlineCell
        
        // Add image to cell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let post = posts[indexPath.row]
        return PostOutlineCell.sizeForPost(post)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = posts[indexPath.row]
        self.optionsButton?.removeFromSuperview()
        performSegueWithIdentifier("showPostDetail", sender: post)
    }
    
    
}

