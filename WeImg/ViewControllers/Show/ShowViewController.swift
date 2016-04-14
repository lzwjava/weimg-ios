//
//  ShowViewController.swift
//  Yep
//
//  Created by nixzhu on 15/8/12.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Ruler

class ShowViewController: BaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: EdgeBorderButton!

    private var isFirstAppear = true

    private var steps = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)

        if isFirstAppear {
            scrollView.alpha = 0
            registerButton.alpha = 0
            loginButton.alpha = 0
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if isFirstAppear {
            UIView.animateWithDuration(1, delay: 0.5, options: .CurveEaseInOut, animations: { [weak self] in
                self?.scrollView.alpha = 1
                self?.registerButton.alpha = 1
                self?.loginButton.alpha = 1
            }, completion: { _ in })
        }

        isFirstAppear = false
    }

    private func makeUI() {
        registerButton.setTitle(NSLocalizedString("Sign Up", comment: ""), forState: .Normal)
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: .Normal)

        registerButton.backgroundColor = UIColor.yepTintColor()
        loginButton.setTitleColor(UIColor.yepInputTextColor(), forState: .Normal)
    }

    // MARK: Actions
    
    @IBAction private func register(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("RegisterPickNameViewController") as! RegisterPickNameViewController
//        let vc = storyboard.instantiateViewControllerWithIdentifier("RegisterPickAvatarViewController") as! RegisterPickAvatarViewController

        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func login(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginByMobileViewController") as! LoginByMobileViewController

        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ShowViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {

        let pageWidth = CGRectGetWidth(scrollView.bounds)
        let pageFraction = scrollView.contentOffset.x / pageWidth

        let page = Int(round(pageFraction))
    }
}

