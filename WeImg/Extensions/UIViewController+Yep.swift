//
//  UIViewController+Yep.swift
//  Yep
//
//  Created by NIX on 15/7/27.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import SafariServices
import PKHUD

// MAKR: - Heights

extension UIViewController {

    var statusBarHeight: CGFloat {

        if let window = view.window {
            let statusBarFrame = window.convertRect(UIApplication.sharedApplication().statusBarFrame, toView: view)
            return statusBarFrame.height

        } else {
            return 0
        }
    }

    var navigationBarHeight: CGFloat {

        if let navigationController = navigationController {
            return navigationController.navigationBar.frame.height

        } else {
            return 0
        }
    }

    var topBarsHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
}

// MAKR: - openURL

extension UIViewController {

    func yep_openURL(URL: NSURL) {

        if #available(iOS 9.0, *) {

            let safariViewController = SFSafariViewController(URL: URL)
            presentViewController(safariViewController, animated: true, completion: nil)

        } else {
            UIApplication.sharedApplication().openURL(URL)
        }
    }
}


extension UIViewController {
    
    func toast(text: String) {
        let textView = PKHUDTextView(text: text)
        PKHUD.sharedHUD.contentView = textView
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2)
    }
    
    func filterError(error: NSError?) -> Bool {
        if let error = error {
            alertError(error) {
                let reason = error.userInfo[NSLocalizedFailureReasonErrorKey]
                if let reasonString = reason as? String {
                    if reasonString == "not_in_session" {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.startShowStory()
                    }
                }
            }
            return false
        } else {
            return true
        }
    }
    
    func alertError(error: NSError, dismissAction: () -> Void) {
        var errorMessage = error.userInfo[NSLocalizedDescriptionKey] as? String
        if errorMessage == nil {
            errorMessage = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        }
        YepAlert.alertSorry(message: errorMessage, inViewController: self, withDismissAction: dismissAction)
    }
    

}