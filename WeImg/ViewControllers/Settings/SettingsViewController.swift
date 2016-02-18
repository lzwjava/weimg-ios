//
//  SettingsViewController.swift
//  Yep
//
//  Created by NIX on 15/4/24.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var settingsTableView: UITableView!

    private let settingsUserCellIdentifier = "SettingsUserCell"
    private let settingsMoreCellIdentifier = "SettingsMoreCell"


    private let moreAnnotations: [[String: String]] = [
        [
            "name": NSLocalizedString("Feedback", comment: ""),
            "segue": "showFeedback",
        ],
        [
            "name": NSLocalizedString("About", comment: ""),
            "segue": "showAbout",
        ],
    ]

    deinit {
        settingsTableView?.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        animatedOnNavigationBar = false

        settingsTableView.registerNib(UINib(nibName: settingsUserCellIdentifier, bundle: nil), forCellReuseIdentifier: settingsUserCellIdentifier)
        settingsTableView.registerNib(UINib(nibName: settingsMoreCellIdentifier, bundle: nil), forCellReuseIdentifier: settingsMoreCellIdentifier)
        
        if let gestures = navigationController?.view.gestureRecognizers {
            for recognizer in gestures {
                if recognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer) {
                    settingsTableView.panGestureRecognizer.requireGestureRecognizerToFail(recognizer as! UIScreenEdgePanGestureRecognizer)
                    println("Require UIScreenEdgePanGestureRecognizer to failed")
                    break
                }
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    private enum Section: Int {
        case User = 0
        case More
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.User.rawValue:
            return 1
        case Section.More.rawValue:
            return moreAnnotations.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {

        case Section.User.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsUserCellIdentifier) as! SettingsUserCell
            return cell

        case Section.More.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsMoreCellIdentifier) as! SettingsMoreCell
            let annotation = moreAnnotations[indexPath.row]
            cell.annotationLabel.text = annotation["name"]
            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {

        case Section.User.rawValue:

            let tableViewWidth = CGRectGetWidth(settingsTableView.bounds)

            let height = max(20 + 8 + 22, 20 + YepConfig.Settings.userCellAvatarSize + 20)

            return height

        case Section.More.rawValue:
            return 60

        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        switch indexPath.section {

        case Section.User.rawValue:
            performSegueWithIdentifier("showEditProfile", sender: nil)

        case Section.More.rawValue:
            let annotation = moreAnnotations[indexPath.row]

            if let segue = annotation["segue"] {
                performSegueWithIdentifier(segue, sender: nil)
            }

        default:
            break
        }
    }
}

