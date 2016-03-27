//
//  EditImageCell.swift
//  WeImg
//
//  Created by lzw on 16/2/8.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Photos

class EditImageCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    
    var imageItem: ImageItem? {
        didSet {
            descTextView.text = self.imageItem?.desc
            PHImageManager.defaultManager().requestImageForAsset(self.imageItem!.asset, targetSize: self.contentImageView.bounds.size, contentMode: .Default, options: nil) { (result: UIImage?, info: [NSObject : AnyObject]?) -> Void in
                self.contentImageView.image = result
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descTextView.text = nil
        descTextView.placeholder = "描述"
        descTextView.backgroundColor = UIColor.clearColor()
        descTextView.textColor = UIColor.blackColor()
        
        selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidChange(textView: UITextView) {
        self.imageItem?.desc = textView.text
    }
    
}
