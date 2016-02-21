//
//  EditImageCell.swift
//  WeImg
//
//  Created by lzw on 16/2/8.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Photos

class EditImageCell: UITableViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var descTextField: UITextField!
    
    var imageItem: ImageItem? {
        didSet {
            descTextField.text = self.imageItem?.desc
            PHImageManager.defaultManager().requestImageForAsset(self.imageItem!.asset, targetSize: self.contentImageView.bounds.size, contentMode: .Default, options: nil) { (result: UIImage?, info: [NSObject : AnyObject]?) -> Void in
                self.contentImageView.image = result
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func descValueChanged(sender: AnyObject) {
        self.imageItem?.desc = descTextField.text
    }
    
}
