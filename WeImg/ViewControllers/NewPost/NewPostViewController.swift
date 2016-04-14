//
//  NewPostViewController.swift
//  WeImg
//
//  Created by lzw on 16/2/8.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Photos
import QBImagePickerController
import PKHUD

class NewPostViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, QBImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let editImageIdentifier = "EditImageCell";
    private let addImageIdentifier = "AddImageCell"
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var imageTableView: UITableView!
    var selectedItems = [ImageItem]();
    private var pickerController: QBImagePickerController = {
        let picker = QBImagePickerController()
        picker.mediaType = QBImagePickerMediaType.Any
        picker.allowsMultipleSelection = true
        picker.showsNumberOfSelectedAssets = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.registerNib(UINib(nibName: editImageIdentifier, bundle: nil), forCellReuseIdentifier: editImageIdentifier)
        imageTableView.registerNib(UINib(nibName: addImageIdentifier, bundle: nil), forCellReuseIdentifier: addImageIdentifier)
        pickerController.delegate = self
        setTitleField()
    }
    
    private func setTitleField() {
        titleField.attributedPlaceholder = NSAttributedString(string: "标题", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        titleField.layer.borderColor = UIColor.grayColor().CGColor
        titleField.layer.borderWidth = 1.0
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
        if indexPath.row == selectedItems.count {
            self.pickerController.minimumNumberOfSelection = 0;
            self.presentViewController(self.pickerController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    private func buildImageItems(assets: [PHAsset]) -> [ImageItem] {
        var newItems = [ImageItem]()
        for asset in assets {
            let newItem = ImageItem()
            newItem.asset = asset
            for item in selectedItems {
                if item.asset.burstIdentifier == asset.burstIdentifier {
                    newItem.desc = item.desc
                }
            }
            newItems.append(newItem)
        }
        return newItems
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        dismissViewControllerAnimated(true, completion: nil)
        selectedItems = buildImageItems(assets as! [PHAsset])
        imageTableView.reloadData()
    }

    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadImages(sender: AnyObject) {
        if titleField.text?.characters.count <= 0 {
            toast("请输入标题")
            return
        }
        if (selectedItems.count == 0) {
            toast("请至少选择一张照片")
            return
        }
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            PostManager.manager.createPost(self.titleField.text!, imageItems: self.selectedItems) { (error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    PKHUD.sharedHUD.hide(animated: true, completion: nil)
                    if self.filterError(error) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }
        })
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
