//
//  RegisterPickNameViewController.swift
//  Yep
//
//  Created by NIX on 15/3/16.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Ruler

class RegisterPickPasswordViewController: BaseViewController {

    @IBOutlet private weak var pickPasswordPromptLabel: UILabel!
    @IBOutlet private weak var pickPasswordPromptLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var passwordTextField: BorderTextField!
    @IBOutlet private weak var passwordTextFieldTopConstraint: NSLayoutConstraint!
    
    private lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .Plain, target: self, action: "next:")
        return button
    }()

    private var isDirty = false {
        willSet {
            nextButton.enabled = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        animatedOnNavigationBar = false

        view.backgroundColor = UIColor.yepViewBackgroundColor()

        navigationItem.titleView = NavigationTitleLabel(title: NSLocalizedString("Sign Up", comment: ""))

        navigationItem.rightBarButtonItem = nextButton

        pickPasswordPromptLabel.text = NSLocalizedString("Your password?", comment: "")

        passwordTextField.backgroundColor = UIColor.whiteColor()
        passwordTextField.textColor = UIColor.yepInputTextColor()
        passwordTextField.placeholder = " "//NSLocalizedString("Nickname", comment: "")
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)

        pickPasswordPromptLabelTopConstraint.constant = Ruler.iPhoneVertical(30, 50, 60, 60).value
        passwordTextFieldTopConstraint.constant = Ruler.iPhoneVertical(30, 40, 50, 50).value

        nextButton.enabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        passwordTextField.becomeFirstResponder()
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        isDirty = !text.isEmpty
    }

    @objc private func next(sender: UIBarButtonItem) {
        showRegisterPickMobile()
    }

    private func showRegisterPickMobile() {

        guard let text = passwordTextField.text else {
            return
        }

        let password = text.trimming(.WhitespaceAndNewline)
        UserManager.manager.pickedPassword = password;
//        YepUserDefaults.nickname.value = nickname

        performSegueWithIdentifier("showRegisterPickMobile", sender: nil)
    }
}

extension RegisterPickPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        guard let text = textField.text else {
            return true
        }

        if !text.isEmpty {
            showRegisterPickMobile()
        }

        return true
    }
}

