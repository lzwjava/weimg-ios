//
//  EditUsernameController.swift
//  Yep
//
//  Created by NIX on 15/7/2.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Ruler

class EditUsernameController: UITableViewController {

    @IBOutlet private weak var nicknameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Nickname", comment: "")

        nicknameTextField.text = UserManager.currentUser?.username
        nicknameTextField.delegate = self
        
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)

        guard let newNickname = nicknameTextField.text else {
            return
        }

        if newNickname != UserManager.currentUser?.username {

//            updateMyselfWithInfo(["nickname": newNickname], failureHandler: nil, completion: { success in
//                dispatch_async(dispatch_get_main_queue()) {
//                    YepUserDefaults.nickname.value = newNickname
//                }
//            })
        }
    }
}

extension EditUsernameController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField == nicknameTextField {

            textField.resignFirstResponder()

            guard let newNickname = textField.text else {
                return true
            }

            if newNickname.isEmpty {
                YepAlert.alertSorry(message: NSLocalizedString("You did not enter any nickname!", comment: ""), inViewController: self, withDismissAction: {
                    dispatch_async(dispatch_get_main_queue()) {
                        textField.text = UserManager.currentUser?.username
                    }
                })

            } else {
                if newNickname != UserManager.currentUser?.username {
//
//                    updateMyselfWithInfo(["nickname": newNickname], failureHandler: { [weak self] reason, errorMessage in
//                        defaultFailureHandler(reason, errorMessage: errorMessage)
//
//                        YepAlert.alertSorry(message: NSLocalizedString("Update nickname failed!", comment: ""), inViewController: self)
//
//                    }, completion: { success in
//                        dispatch_async(dispatch_get_main_queue()) {
//                            YepUserDefaults.nickname.value = newNickname
//                        }
//                    })
                }
            }
        }

        return true
    }
}