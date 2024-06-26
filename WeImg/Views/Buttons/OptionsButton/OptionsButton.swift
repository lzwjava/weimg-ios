//
//  OptionsButton.swift
//  WeImg
//
//  Created by lzw on 16/2/15.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class OptionsButton: UIView {
    
    @IBOutlet weak var circleStackView: UIStackView!
    
    @IBOutlet weak var contentStackView: UIStackView!

    @IBOutlet weak var optionTitleLabel: UILabel!
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    var selectAction: (Int -> Void)?
    
    var options = [String]() {
        didSet {
            circleStackView.subviews.forEach({ $0.removeFromSuperview()})
            for index in 0...(options.count - 1) {
                let circleView = CircleView.instanceFromNib()
                circleView.tag = 100 + index
                circleStackView.addArrangedSubview(circleView)
            }
//            print(contentStackView.frame)
//            print(self.frame)
//            let frame = contentStackView.frame
//            let newFrame = CGRectMake(0, 0, frame.width + 5, frame.height)
//            print(newFrame)
//            self.frame = newFrame
            if options.count > 0 {
                selectedIndex = 0
            }
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            for index in 0...(options.count - 1) {
                let circleView = circleStackView.viewWithTag(100 + index) as! CircleView
                circleView.selected = selectedIndex == index
            }
            let option = options[selectedIndex!]
            optionTitleLabel.text = option
        }
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        
        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        self.tapGestureRecognizer = tap
        self.addGestureRecognizer(tap)
    }
    
    deinit {
        if let tap = self.tapGestureRecognizer {
            self.removeGestureRecognizer(tap)
        }
    }
    
    func tapAction(sender: AnyObject) {
        if let selectedIndex = selectedIndex {
            self.selectedIndex = (selectedIndex + 1) % options.count
            selectAction?(self.selectedIndex!)
        }
    }
    
    class func instanceFromNib() -> OptionsButton {
        return UINib(nibName: "OptionsButton", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! OptionsButton
    }

}
