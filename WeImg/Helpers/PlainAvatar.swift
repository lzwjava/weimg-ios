//
//  PlainAvatar.swift
//  Yep
//
//  Created by nixzhu on 15/10/20.
//  Copyright © 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Navi

private let screenScale = UIScreen.mainScreen().scale

struct PlainAvatar {

    let avatarUrl: String
    let avatarStyle: AvatarStyle
}

extension PlainAvatar: Navi.Avatar {

    var URL: NSURL? {
        return NSURL(string: avatarUrl)
    }

    var style: AvatarStyle {
        return avatarStyle
    }

    var placeholderImage: UIImage? {

        switch style {

        case miniAvatarStyle:
            return UIImage(named: "default_avatar_60")

        case nanoAvatarStyle:
            return UIImage(named: "default_avatar_40")

        case picoAvatarStyle:
            return UIImage(named: "default_avatar_30")

        default:
            return nil
        }
    }

    var localOriginalImage: UIImage? {

        if let
            avatar = avatarWithAvatarURLString(avatarUrl),
            avatarFileURL = NSFileManager.yepAvatarURLWithName(avatar.avatarFileName),
            avatarFilePath = avatarFileURL.path,
            image = UIImage(contentsOfFile: avatarFilePath) {
                return image
        }

        return nil
    }

    var localStyledImage: UIImage? {

        switch style {

        case miniAvatarStyle:
            if let
                avatar = avatarWithAvatarURLString(avatarUrl) {
                    return UIImage(data: avatar.roundMini, scale: screenScale)
            }

        case nanoAvatarStyle:
            if let
                avatar = avatarWithAvatarURLString(avatarUrl) {
                    return UIImage(data: avatar.roundNano, scale: screenScale)
            }

        default:
            break
        }

        return nil
    }

    func saveOriginalImage(originalImage: UIImage, styledImage: UIImage) {
        var _avatar = avatarWithAvatarURLString(avatarUrl)

        if _avatar == nil {

            let newAvatar = Avatar()
            newAvatar.avatarUrl = avatarUrl
//
//            let _ = try? realm.write {
//                realm.add(newAvatar)
//            }

            _avatar = newAvatar
        }

        guard let avatar = _avatar else {
            return
        }

        let avatarFileName = NSUUID().UUIDString

        if avatar.avatarFileName.isEmpty, let _ = NSFileManager.saveAvatarImage(originalImage, withName: avatarFileName) {

//            let _ = try? realm.write {
//                avatar.avatarFileName = avatarFileName
//            }
        }

        switch style {

        case .RoundedRectangle(let size, _, _):

            switch size.width {

            case 60:
                if avatar.roundMini.length == 0, let data = UIImagePNGRepresentation(styledImage) {
//                    let _ = try? realm.write {
//                        avatar.roundMini = data
//                    }
                }

            case 40:
                if avatar.roundNano.length == 0, let data = UIImagePNGRepresentation(styledImage) {
//                    let _ = try? realm.write {
//                        avatar.roundNano = data
//                    }
                }

            default:
                break
            }

        default:
            break
        }
    }
}

