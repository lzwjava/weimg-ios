//
//  RegisterVerifyMobileViewController.swift
//  Yep
//
//  Created by NIX on 15/3/17.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Ruler

class RegisterVerifyMobileViewController: BaseViewController {

    var mobile: String!
    var areaCode: String!

    
    @IBOutlet private weak var verifyMobileNumberPromptLabel: UILabel!
    @IBOutlet private weak var verifyMobileNumberPromptLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var phoneNumberLabel: UILabel!

    @IBOutlet private weak var verifyCodeTextField: BorderTextField!
    @IBOutlet private weak var verifyCodeTextFieldTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var callMePromptLabel: UILabel!
    @IBOutlet private weak var callMeButton: UIButton!
    @IBOutlet private weak var callMeButtonTopConstraint: NSLayoutConstraint!

    private lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .Plain, target: self, action: "next:")
        return button
    }()
    
    private lazy var callMeTimer: NSTimer = {
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tryCallMe:", userInfo: nil, repeats: true)
        return timer
    }()

    private var haveAppropriateInput = false {
        willSet {
            nextButton.enabled = newValue

            if newValue {
                verifyRegisterMobile()
            }
        }
    }

    private var callMeInSeconds = 60;

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = NavigationTitleLabel(title: NSLocalizedString("Sign Up", comment: ""))

        navigationItem.rightBarButtonItem = nextButton

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeAgain:", name: "applicationDidBecomeActive", object: nil)

        verifyMobileNumberPromptLabel.text = NSLocalizedString("Input verification code sent to", comment: "")
        phoneNumberLabel.text = "+" + areaCode + " " + mobile

        verifyCodeTextField.placeholder = " "
        verifyCodeTextField.backgroundColor = UIColor.whiteColor()
        verifyCodeTextField.textColor = UIColor.yepInputTextColor()
        verifyCodeTextField.delegate = self
        verifyCodeTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)

        callMePromptLabel.text = NSLocalizedString("Didn't get it?", comment: "")
        callMeButton.setTitle(NSLocalizedString("Call me", comment: ""), forState: .Normal)

        verifyMobileNumberPromptLabelTopConstraint.constant = Ruler.iPhoneVertical(30, 50, 60, 60).value
        verifyCodeTextFieldTopConstraint.constant = Ruler.iPhoneVertical(30, 40, 50, 50).value
        callMeButtonTopConstraint.constant = Ruler.iPhoneVertical(10, 20, 40, 40).value
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        nextButton.enabled = false
        callMeButton.enabled = false

        verifyCodeTextField.text = nil
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        verifyCodeTextField.becomeFirstResponder()

        callMeTimer.fire()
    }

    // MARK: Actions

    @objc private func activeAgain(notification: NSNotification) {
        verifyCodeTextField.becomeFirstResponder()
    }

    @objc private func tryCallMe(timer: NSTimer) {
        if !haveAppropriateInput {
            if callMeInSeconds > 1 {
                let callMeInSecondsString = NSLocalizedString("Call me", comment: "") + " (\(callMeInSeconds))"

                UIView.performWithoutAnimation {
                    self.callMeButton.setTitle(callMeInSecondsString, forState: .Normal)
                    self.callMeButton.layoutIfNeeded()
                }

            } else {
                UIView.performWithoutAnimation {
                    self.callMeButton.setTitle(NSLocalizedString("Call me", comment: ""), forState: .Normal)
                    self.callMeButton.layoutIfNeeded()
                }

                callMeButton.enabled = true
            }
        }

        if (callMeInSeconds > 1) {
            callMeInSeconds--
        }
    }

    @IBAction private func callMe(sender: UIButton) {

        callMeTimer.invalidate()

        UIView.performWithoutAnimation {
            self.callMeButton.setTitle(NSLocalizedString("Calling", comment: ""), forState: .Normal)
            self.callMeButton.layoutIfNeeded()
        }

        delay(5) {
            UIView.performWithoutAnimation {
                self.callMeButton.setTitle(NSLocalizedString("Call me", comment: ""), forState: .Normal)
                self.callMeButton.layoutIfNeeded()
            }
        }
        
        UserManager.manager.register(UserManager.manager.pickedMobilePhoneNumber!, password: "123456", smsCode: areaCode, username: UserManager.manager.pickedUsername!) { (error: NSError?) -> Void in
            
        }

//        sendVerifyCodeOfMobile(mobile, withAreaCode: areaCode, useMethod: .Call, failureHandler: { (reason, errorMessage) in
//            defaultFailureHandler(reason, errorMessage: errorMessage)
//
//            if let errorMessage = errorMessage {
//                dispatch_async(dispatch_get_main_queue()) { [weak self] in
//                    YepAlert.alertSorry(message: errorMessage, inViewController: self)
//
//                    UIView.performWithoutAnimation {
//                        self?.callMeButton.setTitle(NSLocalizedString("Call me", comment: ""), forState: .Normal)
//                        self?.callMeButton.layoutIfNeeded()
//                    }
//                }
//            }
//
//        }, completion: { success in
//            println("resendVoiceVerifyCode \(success)")
//        })
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        haveAppropriateInput = (text.characters.count == YepConfig.verifyCodeLength())
    }

    @objc private func next(sender: UIBarButtonItem) {
        verifyRegisterMobile()
    }

    private func verifyRegisterMobile() {

        view.endEditing(true)

        guard let verifyCode = verifyCodeTextField.text else {
            return
        }

        YepHUD.showActivityIndicator()
        
        if let phone = UserManager.manager.pickedMobilePhoneNumber,
            password = UserManager.manager.pickedPassword,
            username = UserManager.manager.pickedUsername {
            UserManager.manager.register(phone, password: password, smsCode: verifyCode, username: username) { (error: NSError?) -> Void in
                YepHUD.hideActivityIndicator()
                if let error = error {
                    self.nextButton.enabled = false
                    self.alertError(error, dismissAction: { () -> Void in
                        self.verifyCodeTextField.becomeFirstResponder()
                    })
                } else {
                    self.performSegueWithIdentifier("showRegisterPickAvatar", sender: nil)
                }
            }
        }
        

//        verifyMobile(mobile, withAreaCode: areaCode, verifyCode: verifyCode, failureHandler: { [weak self] (reason, errorMessage) in
//            defaultFailureHandler(reason, errorMessage: errorMessage)
//
//            YepHUD.hideActivityIndicator()
//
//            if let errorMessage = errorMessage {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self?.nextButton.enabled = false
//
//                    YepAlert.alertSorry(message: errorMessage, inViewController: self, withDismissAction: { [weak self] in
//                        self?.verifyCodeTextField.becomeFirstResponder()
//                    })
//                }
//            }
//
//        }, completion: { loginUser in
//
//            println("\(loginUser)")
//
//            YepHUD.hideActivityIndicator()
//
//            dispatch_async(dispatch_get_main_queue()) {
//
//                saveTokenAndUserInfoOfLoginUser(loginUser)
//
//                self.performSegueWithIdentifier("showRegisterPickAvatar", sender: nil)
//            }
//        })
    }
}

extension RegisterVerifyMobileViewController: UITextFieldDelegate {

    /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if haveAppropriateInput {
            verifyRegisterMobile()
        }

        return true
    }
    */
}

