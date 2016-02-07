//
//  NewPostViewController.swift
//  WeImg
//
//  Created by lzw on 16/2/8.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Photos

class NewPostViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let editImageIdentifier = "EditImageCell";
    private let addImageIdentifier = "AddImageCell"
    
    @IBOutlet weak var imageTableView: UITableView!
    var selectedItems = [ImageItem]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
        self.imageTableView.registerNib(UINib(nibName: editImageIdentifier, bundle: nil), forCellReuseIdentifier: editImageIdentifier)
        self.imageTableView.registerNib(UINib(nibName: addImageIdentifier, bundle: nil), forCellReuseIdentifier: addImageIdentifier)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < selectedItems.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(editImageIdentifier) as! EditImageCell
            cell.imageItem = self.selectedItems[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(addImageIdentifier)
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row <= selectedItems.count {
            
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
}
