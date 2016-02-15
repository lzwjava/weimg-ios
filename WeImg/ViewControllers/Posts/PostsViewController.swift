//
//  ViewController.swift
//  CHTWaterfallSwift
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit
import Kingfisher

class PostsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl?
    var posts = [Post]()
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Attach datasource and delegate
        self.collectionView.dataSource  = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        //Layout setup
        setupCollectionView()
        
        //Register nibs
        registerNibs()
        
        loadPosts(false)
    }
    
    private func loadPosts(refresh: Bool) {
        PostManager.manager.getPosts(0, limit: 100) { (fetchedPosts: [Post], error: NSError?) -> Void in
            if refresh {
                self.refreshControl?.endRefreshing()
            }
            if (self.filterError(error)) {
                self.posts = fetchedPosts
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CollectionView UI Setup
    func setupCollectionView(){
        
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
        collectionView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        loadPosts(true)
    }
    
    // Register CollectionView Nibs
    func registerNibs(){
        
        // attach the UI nib file for the PostOutlineCell to the collectionview 
        let viewNib = UINib(nibName: "PostOutlineCell", bundle: nil)
        collectionView.registerNib(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    //MARK: - CollectionView Delegate Methods
    
     //** Number of Cells in the CollectionView */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //** Create a basic CollectionView Cell */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Create the cell and return the cell
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
        performSegueWithIdentifier("showPostDetail", sender: post)
    }
    
    @IBAction func newButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("showNewPost", sender: nil)
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

