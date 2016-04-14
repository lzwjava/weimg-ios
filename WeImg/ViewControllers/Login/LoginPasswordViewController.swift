//
//  LoginPasswordViewController.swift
//  Yep
//
//  Created by NIX on 15/3/17.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Ruler

class LoginPasswordViewController: BaseViewController {

    var mobile: String!
    var areaCode: String!

    @IBOutlet private weak var verifyMobileNumberPromptLabel: UILabel!
    @IBOutlet private weak var verifyMobileNumberPromptLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var verifyCodeTextField: BorderTextField!
    @IBOutlet private weak var verifyCodeTextFieldTopConstraint: NSLayoutConstraint!

    private lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .Plain, target: self, action: "next:")
        return button
    }()

    private var haveAppropriateInput = false {
        willSet {
            nextButton.enabled = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = NavigationTitleLabel(title: NSLocalizedString("Login", comment: ""))

        navigationItem.rightBarButtonItem = nextButton

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeAgain:", name: "applicationDidBecomeActive", object: nil)
        
        verifyMobileNumberPromptLabel.text = NSLocalizedString("Your password?", comment: "")

        verifyCodeTextField.placeholder = " "
        verifyCodeTextField.delegate = self
        verifyCodeTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)

        verifyMobileNumberPromptLabelTopConstraint.constant = Ruler.iPhoneVertical(30, 50, 60, 60).value
        verifyCodeTextFieldTopConstraint.constant = Ruler.iPhoneVertical(30, 40, 50, 50).value
        
//        verifyCodeTextField.text = "123456"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        nextButton.enabled = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        verifyCodeTextField.becomeFirstResponder()
    }

    // MARK: Actions

    @objc private func activeAgain(notification: NSNotification) {
        verifyCodeTextField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        haveAppropriateInput = (text.characters.count >= YepConfig.minPasswordLength())
    }

    @objc private func next(sender: UIBarButtonItem) {
        login()
    }

    private func login() {

        view.endEditing(true)

        guard let password = verifyCodeTextField.text else {
            return
        }

        YepHUD.showActivityIndicator()
        UserManager.manager.login(mobile, password: password) { (error: NSError?) -> Void in
            YepHUD.hideActivityIndicator()
            if let error = error {
                self.nextButton.enabled = false
                self.alertError(error, dismissAction: { () -> Void in
                    self.verifyCodeTextField.becomeFirstResponder()
                })
            } else {
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.startMainStory()
                }
            }
        }
    }
}

extension LoginPasswordViewController: UITextFieldDelegate {

    /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if haveAppropriateInput {
            login()
        }
        
        return true
    }
    */
}

