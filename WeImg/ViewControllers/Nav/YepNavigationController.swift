//
//  YepNavigationController.swift
//  Yep
//
//  Created by kevinzhow on 15/5/27.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class YepNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if respondsToSelector("interactivePopGestureRecognizer") {
            interactivePopGestureRecognizer?.delegate = self
            
            delegate = self
        }
        
//        self.navigationBar.tintColor = UIColor.yepBarButtonColor()
//        self.navigationBar.changeBottomHairImage()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if respondsToSelector("interactivePopGestureRecognizer") && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if respondsToSelector("interactivePopGestureRecognizer") && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if respondsToSelector("interactivePopGestureRecognizer") && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToViewController(viewController, animated: false)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if respondsToSelector("interactivePopGestureRecognizer") {
            interactivePopGestureRecognizer?.enabled = true
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }
}

