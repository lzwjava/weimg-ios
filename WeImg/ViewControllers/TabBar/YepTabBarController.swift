//
//  YepTabBarController.swift
//  Yep
//
//  Created by kevinzhow on 15/3/28.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class YepTabBarController: UITabBarController {

    private enum Tab: Int {

        case Posts
        case Setting

        var title: String {

            switch self {
            case .Posts:
                return NSLocalizedString("HomePage", comment: "")
            case .Setting:
                return NSLocalizedString("Settings", comment: "")
            }
        }
    }

    private var previousTab = Tab.Posts

    private var checkDoubleTapOnFeedsTimer: NSTimer?
    private var hasFirstTapOnFeedsWhenItIsAtTop = false {
        willSet {
            if newValue {
                let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkDoubleTapOnFeeds:", userInfo: nil, repeats: false)
                checkDoubleTapOnFeedsTimer = timer

            } else {
                checkDoubleTapOnFeedsTimer?.invalidate()
            }
        }
    }

    @objc private func checkDoubleTapOnFeeds(timer: NSTimer) {

        hasFirstTapOnFeedsWhenItIsAtTop = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        view.backgroundColor = UIColor.whiteColor()

        // 将 UITabBarItem 的 image 下移一些，也不显示 title 了
        /*
        if let items = tabBar.items as? [UITabBarItem] {
            for item in items {
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                item.title = nil
            }
        }
        */

        // Set Titles

//        if let items = tabBar.items {
//            for i in 0..<items.count {
//                let item = items[i]
//                item.title = Tab(rawValue: i)?.title
//            }
//        }

//        // 处理启动切换
//
//        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
//            appDelegate.lauchStyle.bindListener(Listener.lauchStyle) { [weak self] style in
//                if style == .Message {
//                    self?.selectedIndex = 0
//                }
//            }
//        }
        
        if let vcs = self.viewControllers {
            for vc in vcs {
                vc.title = nil
                vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
        }
        
        setUpTabBar()
    }
    
    func setUpTabBar() {
        let tabBar = self.tabBar as! TabBar
        tabBar.tabBarBtn.addTarget(self, action: "tabBarButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func tabBarButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("showNewPost", sender: nil)
    }
}

// MARK: - UITabBarControllerDelegate

extension YepTabBarController: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

        guard
            let tab = Tab(rawValue: selectedIndex),
            let nvc = viewController as? UINavigationController else {
                return false
        }

        if tab != previousTab {
            return true
        }
        
        return true
    }

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

        guard
            let tab = Tab(rawValue: selectedIndex),
            let nvc = viewController as? UINavigationController else {
                return
        }

        // 不相等才继续，确保第一次 tap 不做事

        if tab != previousTab {
            previousTab = tab
            return
        }

        switch tab {
        case .Posts:
            if let vc = nvc.topViewController as? PostsViewController {
                if !vc.collectionView.yep_isAtTop {
                    vc.collectionView.yep_scrollsToTop()
                }
            }
            break;
        case .Setting:
            if let vc = nvc.topViewController as? SettingsViewController {
                if !vc.settingsTableView.yep_isAtTop {
                    vc.settingsTableView.yep_scrollsToTop()
                }
            }
            break;
        }
    }
}

