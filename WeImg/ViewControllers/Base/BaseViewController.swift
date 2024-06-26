//
//  BaseViewController.swift
//  Yep
//
//  Created by kevinzhow on 15/5/23.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var animatedOnNavigationBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yepMainColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else {
            return
        }

        navigationController.navigationBar.backgroundColor = nil
        navigationController.navigationBar.translucent = true
        navigationController.navigationBar.shadowImage = nil
        navigationController.navigationBar.barStyle = UIBarStyle.Default
        navigationController.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)

        let textAttributes = [
            NSForegroundColorAttributeName: UIColor.yepNavgationBarTitleColor(),
            NSFontAttributeName: UIFont.navigationBarTitleFont()
        ]

        navigationController.navigationBar.titleTextAttributes = textAttributes
        navigationController.navigationBar.tintColor = nil

        if navigationController.navigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: animatedOnNavigationBar)
        }
    }
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
        if let navigationController = navigationController {
            guard navigationController.topViewController == self else {
                return
            }
        }
        
        super.performSegueWithIdentifier(identifier, sender: sender)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: nil)
        if self.navigationController?.viewControllers.count > 0 {
            segue.destinationViewController.hidesBottomBarWhenPushed = true
        }
    }
}

