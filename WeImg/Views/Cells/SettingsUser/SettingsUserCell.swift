//
//  SettingsUserCell.swift
//  Yep
//
//  Created by NIX on 15/4/24.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Navi

class SettingsUserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var introLabel: UILabel!

    @IBOutlet weak var accessoryImageView: UIImageView!

    struct Listener {
        static let Avatar = "SettingsUserCell.Avatar"
        static let Nickname = "SettingsUserCell.Nickname"
        static let Introduction = "SettingsUserCell.Introduction"
    }

    deinit {
        YepUserDefaults.avatarURLString.removeListenerWithName(Listener.Avatar)
        YepUserDefaults.nickname.removeListenerWithName(Listener.Nickname)
        YepUserDefaults.introduction.removeListenerWithName(Listener.Introduction)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let avatarSize = YepConfig.Settings.userCellAvatarSize
        avatarImageViewWidthConstraint.constant = avatarSize

        YepUserDefaults.avatarURLString.bindAndFireListener(Listener.Avatar) { [weak self] _ in
            dispatch_async(dispatch_get_main_queue()) {
                self?.updateAvatar()
            }
        }

        YepUserDefaults.nickname.bindAndFireListener(Listener.Nickname) { [weak self] nickname in
            dispatch_async(dispatch_get_main_queue()) {
                self?.nameLabel.text = nickname
            }
        }

        YepUserDefaults.introduction.bindAndFireListener(Listener.Introduction) { [weak self] introduction in
            dispatch_async(dispatch_get_main_queue()) {
                self?.introLabel.text = introduction
            }
        }

        introLabel.font = YepConfig.Settings.introFont

        accessoryImageView.tintColor = UIColor.yepCellAccessoryImageViewTintColor()
    }

    func updateAvatar() {

        if let avatarURLString = YepUserDefaults.avatarURLString.value {

            let avatarSize = YepConfig.Settings.userCellAvatarSize
            let avatarStyle: AvatarStyle = .RoundedRectangle(size: CGSize(width: avatarSize, height: avatarSize), cornerRadius: avatarSize * 0.5, borderWidth: 0)
            let plainAvatar = PlainAvatar(avatarURLString: avatarURLString, avatarStyle: avatarStyle)
            avatarImageView.navi_setAvatar(plainAvatar, withFadeTransitionDuration: avatarFadeTransitionDuration)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
