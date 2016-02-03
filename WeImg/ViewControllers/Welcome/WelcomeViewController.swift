//
//  WelcomeViewController.swift
//  Yep
//
//  Created by NIX on 15/3/16.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet private weak var logoLabel: UILabel!
    @IBOutlet private weak var sloganLabel: UILabel!

    @IBOutlet private weak var registerButton: BorderButton!
    @IBOutlet private weak var loginButton: BorderButton!

    @IBOutlet private weak var companyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        logoLabel.text = NSLocalizedString("Yep", comment: "")
        sloganLabel.text = NSLocalizedString("Meet with genius", comment: "")

        registerButton.setTitle(NSLocalizedString("Sign Up", comment: ""), forState: .Normal)
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: .Normal)

        companyLabel.text = NSLocalizedString("Catch Inc.", comment: "")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: Actions

    @IBAction private func register(sender: UIButton) {
        performSegueWithIdentifier("showRegisterPickName", sender: nil)
    }

    @IBAction private func login(sender: UIButton) {
        performSegueWithIdentifier("showLoginByMobile", sender: nil)
    }
}
