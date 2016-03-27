//
//  AddImageCell.swift
//  WeImg
//
//  Created by lzw on 3/26/16.
//  Copyright © 2016 WeImg Inc. All rights reserved.
//

import UIKit
import XXNibBridge

class AddImageCell: UITableViewCell {

    @IBOutlet weak var placeholderView: UIView!
    private var border: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initPlaceholderView();
    }
    
    private func initPlaceholderView() {
        border = CAShapeLayer()
        border.strokeColor = UIColor.rgb(170, 170, 170).CGColor
        border.fillColor = nil
        let pattern:[Int] = [4, 2]
        border.lineDashPattern = pattern
        border.path = UIBezierPath(rect: placeholderView.bounds).CGPath
        placeholderView.layer.addSublayer(border)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
