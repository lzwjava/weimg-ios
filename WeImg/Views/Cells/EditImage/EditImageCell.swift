//
//  EditImageCell.swift
//  WeImg
//
//  Created by lzw on 16/2/8.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Photos

class ImageItem {
    var asset : PHAsset!
    var desc: String?
}

class EditImageCell: UITableViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var descTextField: UITextField!
    
    var imageItem: ImageItem? {
        didSet {
            descTextField.text = self.imageItem?.desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
