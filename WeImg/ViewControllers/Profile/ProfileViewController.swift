//
//  ProfileViewController.swift
//  Yep
//
//  Created by NIX on 15/3/16.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import MonkeyKing
import Navi
import SafariServices
import Kingfisher
import Proposer
import CoreLocation

let profileAvatarAspectRatio: CGFloat = 12.0 / 16.0

enum ProfileUser {
    case DiscoveredUserType(DiscoveredUser)
    case UserType(User)

    var userId: String {
        switch self {
        case .DiscoveredUserType(let discoveredUser):
            return discoveredUser.userId

        case .UserType(let user):
            return user.userId
        }
    }

    var username: String? {

        var username: String? = nil

        switch self {

        case .DiscoveredUserType(let discoveredUser):
            username = discoveredUser.username

        case .UserType(let user):
            if !user.username.isEmpty {
                username = user.username
            }
        }

        return username
    }

    var avatarUrl: String? {

        var avatarUrl: String? = nil

        switch self {

        case .DiscoveredUserType(let discoveredUser):
            avatarUrl = discoveredUser.avatarUrl

        case .UserType(let user):
            if !user.avatarUrl.isEmpty {
                avatarUrl = user.avatarUrl
            }
        }
        
        return avatarUrl
    }

    var isMe: Bool {

        switch self {

        case .DiscoveredUserType(let discoveredUser):
            return discoveredUser.isMe

        case .UserType(let user):
            return user.isMe
        }
    }
    
}

class ProfileViewController: SegueViewController {
    

    enum FromType {
        case None
        case OneToOneConversation
        case GroupConversation
    }
    var fromType: FromType = .None

    var oAuthCompleteAction: (() -> Void)?


    var profileUser: ProfileUser?
    var profileUserIsMe = true {
        didSet {
            if !profileUserIsMe {

            } else {

                let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_settings"), style: .Plain, target: self, action: "showSettings:")

                customNavigationItem.rightBarButtonItem = settingsBarButtonItem
            }
        }
    }

    #if DEBUG
    private lazy var profileFPSLabel: FPSLabel = {
        let label = FPSLabel()
        return label
    }()
    #endif

    private var statusBarShouldLight = false

    private var noNeedToChangeStatusBar = false

    @IBOutlet private weak var topShadowImageView: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!

    private var customNavigationBar: UINavigationBar!

    private let headerCellIdentifier = "ProfileHeaderCell"
    private let footerCellIdentifier = "ProfileFooterCell"
    private let sectionHeaderIdentifier = "ProfileSectionHeaderReusableView"
    private let sectionFooterIdentifier = "ProfileSectionFooterReusableView"
    private let separationLineCellIdentifier = "ProfileSeparationLineCell"

    private lazy var collectionViewWidth: CGFloat = {
        return CGRectGetWidth(self.profileCollectionView.bounds)
    }()
    private lazy var sectionLeftEdgeInset: CGFloat = { return YepConfig.Profile.leftEdgeInset }()
    private lazy var sectionRightEdgeInset: CGFloat = { return YepConfig.Profile.rightEdgeInset }()
    private lazy var sectionBottomEdgeInset: CGFloat = { return 0 }()

    private lazy var introductionText: String = {

        var introduction: String?
        
        func updateIntro(intro: String) {
            self.introductionText = intro
            self.updateProfileCollectionView()
        }

        if let profileUser = self.profileUser {
            switch profileUser {
                
            case .DiscoveredUserType(let discoveredUser):
                if let _introduction = discoveredUser.introduction {
                    if !_introduction.isEmpty {
                        introduction = _introduction
                    }
                }

            case .UserType(let user):

                if !user.introduction.isEmpty {
                    introduction = user.introduction
                }

                if user.friendState == UserFriendState.Me {
//                    YepUserDefaults.introduction.bindListener(self.listener.introduction) { [weak self] introduction in
//                        dispatch_async(dispatch_get_main_queue()) {
//                            if let introduction = introduction {
//
//                            }
//                        }
//                    }
                }
            }
        }

        return introduction ?? NSLocalizedString("No Introduction yet.", comment: "")
    }()


//    private var feeds: [DiscoveredFeed]?
//    private var feedAttachments: [DiscoveredAttachment]?

    private var footerCellHeight: CGFloat {
        let attributes = [NSFontAttributeName: YepConfig.Profile.introductionLabelFont]
        let labelWidth = self.collectionViewWidth - (YepConfig.Profile.leftEdgeInset + YepConfig.Profile.rightEdgeInset)
        let rect = self.introductionText.boundingRectWithSize(CGSize(width: labelWidth, height: CGFloat(FLT_MAX)), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes:attributes, context:nil)
        return 10 + 24 + 4 + 18 + 10 + ceil(rect.height) + 4
    }

    private var customNavigationItem: UINavigationItem = UINavigationItem(title: "Details")

    private struct Listener {
        let nickname: String
        let introduction: String
        let avatar: String
    }

    private lazy var listener: Listener = {

        let suffix = NSUUID().UUIDString

        return Listener(nickname: "Profile.Title" + suffix, introduction: "Profile.introductionText" + suffix, avatar: "Profile.Avatar" + suffix)
    }()

    // MARK: Life cycle

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)

        YepUserDefaults.nickname.removeListenerWithName(listener.nickname)
        YepUserDefaults.introduction.removeListenerWithName(listener.introduction)
        YepUserDefaults.avatarUrl.removeListenerWithName(listener.avatar)

        profileCollectionView?.delegate = nil

        println("deinit ProfileViewController")
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if statusBarShouldLight {
            return UIStatusBarStyle.LightContent
        } else {
            return UIStatusBarStyle.Default
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Kingfisher.ImageCache(name: "default").calculateDiskCacheSizeWithCompletionHandler({ (size) -> () in
            let cacheSize = Double(size)/1000000
            
            println(String(format: "%.2f MB", cacheSize))
            
            if cacheSize > 300 {
                 Kingfisher.ImageCache.defaultCache.clearDiskCache()
            }
        })

        title = NSLocalizedString("Profile", comment: "")

        println("init ProfileViewController \(self)")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cleanForLogout:", name: EditProfileViewController.Notification.Logout, object: nil)

        if let profileUser = profileUser {

            // 如果是 DiscoveredUser，也可能是好友或已存储的陌生人，查询本地 User 替换

            switch profileUser {

            case .DiscoveredUserType(let discoveredUser):

                guard let realm = try? Realm() else {
                    break
                }

                if let user = userWithUserID(discoveredUser.id, inRealm: realm) {
                    
                    self.profileUser = ProfileUser.UserType(user)

                    updateProfileCollectionView()
                    
                    GoogleAnalyticsTrackEvent("Visit Profile", label: user.nickname, value: 0)
                }

            default:
                break
            }
            
            if let realm = try? Realm() {
                
                if let user = userWithUserID(profileUser.userId, inRealm: realm) {
                    
                    if user.friendState == UserFriendState.Normal.rawValue {
                        
                    }
                }
                
            }

        } else {

            // 为空的话就要显示自己
            syncMyInfoAndDoFurtherAction {

                // 提示没有 Skills
                guard let
                    myUserID = YepUserDefaults.userID.value,
                    realm = try? Realm(),
                    me = userWithUserID(myUserID, inRealm: realm) else {
                        return
                }

            }

            if let
                myUserID = YepUserDefaults.userID.value,
                realm = try? Realm(),
                me = userWithUserID(myUserID, inRealm: realm) {
                    profileUser = ProfileUser.UserType(me)

                    updateProfileCollectionView()
            }
        }

        profileUserIsMe = profileUser?.isMe ?? false


        if let profileLayout = profileCollectionView.collectionViewLayout as? ProfileLayout {

            profileLayout.scrollUpAction = { [weak self] progress in

                if let strongSelf = self {
                    let indexPath = NSIndexPath(forItem: 0, inSection: ProfileSection.Header.rawValue)
                    
                    if let coverCell = strongSelf.profileCollectionView.cellForItemAtIndexPath(indexPath) as? ProfileHeaderCell {
                        
                        let beginChangePercentage: CGFloat = 1 - 64 / strongSelf.collectionViewWidth * profileAvatarAspectRatio
                        let normalizedProgressForChange: CGFloat = (progress - beginChangePercentage) / (1 - beginChangePercentage)
                        
                        coverCell.avatarBlurImageView.alpha = progress < beginChangePercentage ? 0 : normalizedProgressForChange
                        
                        
                        let shadowAlpha = 1 - normalizedProgressForChange
                        
                        if shadowAlpha < 0.2 {
                            strongSelf.topShadowImageView.alpha = progress < beginChangePercentage ? 1 : 0.2
                        } else {
                            strongSelf.topShadowImageView.alpha = progress < beginChangePercentage ? 1 : shadowAlpha
                        }

                        
                        coverCell.locationLabel.alpha = progress < 0.5 ? 1 : 1 - min(1, (progress - 0.5) * 2 * 2) // 特别对待，在后半程的前半段即完成 alpha -> 0
                    }
                }
            }
        }

        profileCollectionView.registerNib(UINib(nibName: headerCellIdentifier, bundle: nil), forCellWithReuseIdentifier: headerCellIdentifier)
        profileCollectionView.registerNib(UINib(nibName: footerCellIdentifier, bundle: nil), forCellWithReuseIdentifier: footerCellIdentifier)
        profileCollectionView.registerNib(UINib(nibName: separationLineCellIdentifier, bundle: nil), forCellWithReuseIdentifier: separationLineCellIdentifier)
        profileCollectionView.registerNib(UINib(nibName: sectionHeaderIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        profileCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: sectionFooterIdentifier)

        profileCollectionView.alwaysBounceVertical = true
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        customNavigationBar = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64))
        customNavigationBar.tintColor = UIColor.whiteColor()
        customNavigationBar.tintAdjustmentMode = .Normal
        customNavigationBar.alpha = 0
        customNavigationBar.setItems([customNavigationItem], animated: false)
        view.addSubview(customNavigationBar)
        
        customNavigationBar.backgroundColor = UIColor.clearColor()
        customNavigationBar.translucent = true
        customNavigationBar.shadowImage = UIImage()
        customNavigationBar.barStyle = UIBarStyle.BlackTranslucent
        customNavigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        let textAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.navigationBarTitleFont()
        ]
        
        customNavigationBar.titleTextAttributes = textAttributes

        
        //Make sure when pan edge screen collectionview not scroll
        if let gestures = navigationController?.view.gestureRecognizers {
            for recognizer in gestures {
                if recognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer) {
                    profileCollectionView.panGestureRecognizer.requireGestureRecognizerToFail(recognizer as! UIScreenEdgePanGestureRecognizer)
                    println("Require UIScreenEdgePanGestureRecognizer to failed")
                    break
                }
            }
        }

        if let tabBarController = tabBarController {
            profileCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGRectGetHeight(tabBarController.tabBar.bounds), right: 0)
        }

        if let profileUser = profileUser {

            switch profileUser {

            case .DiscoveredUserType(let discoveredUser):
                customNavigationItem.title = discoveredUser.nickname

            case .UserType(let user):
                customNavigationItem.title = user.nickname

                if user.friendState == UserFriendState.Me {
                    YepUserDefaults.nickname.bindListener(listener.nickname) { [weak self] nickname in
                        dispatch_async(dispatch_get_main_queue()) {
                            self?.customNavigationItem.title = nickname
                        }
                    }

                    YepUserDefaults.avatarUrl.bindListener(listener.avatar) { [weak self] avatarUrl in
                        dispatch_async(dispatch_get_main_queue()) {
                            let indexPath = NSIndexPath(forItem: 0, inSection: ProfileSection.Header.rawValue)
                            if let cell = self?.profileCollectionView.cellForItemAtIndexPath(indexPath) as? ProfileHeaderCell {
                                if let avatarUrl = avatarUrl {
                                    cell.blurredAvatarImage = nil // need reblur
                                    cell.updateAvatarWithAvatarURLString(avatarUrl)
                                }
                            }
                        }
                    }
                }
            }

            if !profileUserIsMe {

                let userID = profileUser.userId

                userInfoOfUserWithUserID(userID, failureHandler: nil, completion: { userInfo in
                    //println("userInfoOfUserWithUserID \(userInfo)")

                    // 对非好友来说，必要

                    dispatch_async(dispatch_get_main_queue()) { [weak self] in

                        if let realm = try? Realm() {
                            let _ = try? realm.write {
                                updateUserWithUserID(userID, useUserInfo: userInfo, inRealm: realm)
                            }
                        }

                        if let discoveredUser = parseDiscoveredUser(userInfo) {
                            switch profileUser {
                            case .DiscoveredUserType:
                                self?.profileUser = ProfileUser.DiscoveredUserType(discoveredUser)
                            default:
                                break
                            }
                        }
                        
                        self?.updateProfileCollectionView()
                    }
                })
            }

            if profileUserIsMe {

                // share my profile button

                if customNavigationItem.leftBarButtonItem == nil {
                    let shareMyProfileButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "tryShareMyProfile:")
                    customNavigationItem.leftBarButtonItem = shareMyProfileButton
                }

            } else {
                // share others' profile button

                if let _ = profileUser.username {
                    let shareOthersProfileButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareOthersProfile:")
                    customNavigationItem.rightBarButtonItem = shareOthersProfileButton
                }
            }
        }

        if profileUserIsMe {
            proposeToAccess(.Location(.WhenInUse), agreed: {
                YepLocationService.turnOn()

                YepLocationService.sharedManager.afterUpdatedLocationAction = { [weak self] newLocation in

                    let indexPath = NSIndexPath(forItem: 0, inSection: ProfileSection.Footer.rawValue)
                    if let cell = self?.profileCollectionView.cellForItemAtIndexPath(indexPath) as? ProfileFooterCell {
                        cell.location = newLocation
                    }
                }

            }, rejected: {
                println("Yep can NOT get Location. :[\n")
            })
        }

        #if DEBUG
//            view.addSubview(profileFPSLabel)
        #endif
    }

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        customNavigationBar.alpha = 1.0

        statusBarShouldLight = false

        if noNeedToChangeStatusBar {
            statusBarShouldLight = true
        }

        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        statusBarShouldLight = true

        self.setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: Actions

    private func shareProfile() {

         if let username = profileUser?.username, profileURL = NSURL(string: "http://soyep.com/\(username)"), nickname = profileUser?.nickname {

            var thumbnail: UIImage?

            if let
                avatarUrl = profileUser?.avatarUrl,
                realm = try? Realm(),
                avatar = avatarWithAvatarURLString(avatarUrl, inRealm: realm) {
                    if let
                        avatarFileURL = NSFileManager.yepAvatarURLWithName(avatar.avatarFileName),
                        avatarFilePath = avatarFileURL.path,
                        image = UIImage(contentsOfFile: avatarFilePath) {
                            thumbnail = image.navi_centerCropWithSize(CGSize(width: 100, height: 100))
                    }
            }

            let info = MonkeyKing.Info(
                //title: String(format:NSLocalizedString("Yep! I'm %@.", comment: ""), nickname),
                title: nickname,
                description: NSLocalizedString("From Yep, with Skills.", comment: ""),
                thumbnail: thumbnail,
                media: .URL(profileURL)
            )

            let sessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))

            let weChatSessionActivity = WeChatActivity(
                type: .Session,
                message: sessionMessage,
                finish: { success in
                    println("share Profile to WeChat Session success: \(success)")
                    GoogleAnalyticsTrackSocial("WeChat Session", action: "Profile", target: profileURL.absoluteString)
                }
            )

            let timelineMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))

            let weChatTimelineActivity = WeChatActivity(
                type: .Timeline,
                message: timelineMessage,
                finish: { success in
                    println("share Profile to WeChat Timeline success: \(success)")
                    GoogleAnalyticsTrackSocial("WeChat Timeline", action: "Profile", target: profileURL.absoluteString)
                }
            )
            
            GoogleAnalyticsTrackSocial("Share", action: "Profile", target: profileURL.absoluteString)

            let activityViewController = UIActivityViewController(activityItems: ["\(nickname), \(NSLocalizedString("From Yep, with Skills.", comment: "")) \(profileURL)"], applicationActivities: [weChatSessionActivity, weChatTimelineActivity])

            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }

    @objc private func tryShareMyProfile(sender: AnyObject?) {

        if let _ = profileUser?.username {
            
            if let profileUser = profileUser {
                GoogleAnalyticsTrackEvent("Share Profile", label: "\(profileUser.nickname) \(profileUser.userId)", value: 0)
            }
            
            shareProfile()

        } else {

            YepAlert.textInput(title: NSLocalizedString("Create a username", comment: ""), message: NSLocalizedString("In order to share your profile, create a unique username first.", comment: ""), placeholder: NSLocalizedString("use letters, numbers, and underscore", comment: ""), oldText: nil, confirmTitle: NSLocalizedString("Create", comment: ""), cancelTitle: NSLocalizedString("Cancel", comment: ""), inViewController: self, withConfirmAction: { text in

                let newUsername = text

                updateMyselfWithInfo(["username": newUsername], failureHandler: { [weak self] reason, errorMessage in
                    defaultFailureHandler(reason, errorMessage: errorMessage)

                    YepAlert.alertSorry(message: errorMessage ?? NSLocalizedString("Create username failed!", comment: ""), inViewController: self)

                }, completion: { success in
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        guard let realm = try? Realm() else {
                            return
                        }
                        if let
                            myUserID = YepUserDefaults.userID.value,
                            me = userWithUserID(myUserID, inRealm: realm) {
                                let _ = try? realm.write {
                                    me.username = newUsername
                                }
                        }

                        self?.shareProfile()
                    }
                })

            }, cancelAction: {
            })
        }
    }

    @objc private func shareOthersProfile(sender: AnyObject) {
        shareProfile()
    }

    @objc private func showSettings(sender: AnyObject) {
        self.performSegueWithIdentifier("showSettings", sender: self)
    }

    func setBackButtonWithTitle() {
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "popBack:")

        customNavigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc private func popBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @objc private func cleanForLogout(sender: NSNotification) {
        profileUser = nil
    }

    private func updateProfileCollectionView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.profileCollectionView.collectionViewLayout.invalidateLayout()
            self.profileCollectionView.reloadData()
            self.profileCollectionView.layoutIfNeeded()
        }
    }

    /*
    func moreAction() {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

        let toggleDisturbAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Do not disturb", comment: ""), style: .Default) { action -> Void in
            // TODO: toggleDisturbAction
        }
        alertController.addAction(toggleDisturbAction)

        let reportAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Report", comment: ""), style: .Default) { action -> Void in

            let reportWithReason: ReportReason -> Void = { reason in

                if let profileUser = self.profileUser {

                    reportProfileUser(profileUser, forReason: reason, failureHandler: { (reason, errorMessage) in
                        defaultFailureHandler(reason, errorMessage)

                        if let errorMessage = errorMessage {
                            dispatch_async(dispatch_get_main_queue()) {
                                YepAlert.alertSorry(message: errorMessage, inViewController: self)
                            }
                        }

                    }, completion: { success in
                        dispatch_async(dispatch_get_main_queue()) {
                            YepAlert.alert(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Report recorded!", comment: ""), dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: self, withDismissAction: nil)
                        }
                    })
                }
            }

            let reportAlertController = UIAlertController(title: NSLocalizedString("Report Reason", comment: ""), message: nil, preferredStyle: .ActionSheet)

            let pornoReasonAction: UIAlertAction = UIAlertAction(title: ReportReason.Porno.description, style: .Default) { action -> Void in
                reportWithReason(.Porno)
            }
            reportAlertController.addAction(pornoReasonAction)

            let advertisingReasonAction: UIAlertAction = UIAlertAction(title: ReportReason.Advertising.description, style: .Default) { action -> Void in
                reportWithReason(.Advertising)
            }
            reportAlertController.addAction(advertisingReasonAction)

            let scamsReasonAction: UIAlertAction = UIAlertAction(title: ReportReason.Scams.description, style: .Default) { action -> Void in
                reportWithReason(.Scams)
            }
            reportAlertController.addAction(scamsReasonAction)

            let otherReasonAction: UIAlertAction = UIAlertAction(title: ReportReason.Other("").description, style: .Default) { action -> Void in
                YepAlert.textInput(title: NSLocalizedString("Other Reason", comment: ""), placeholder: nil, oldText: nil, confirmTitle: NSLocalizedString("OK", comment: ""), cancelTitle: NSLocalizedString("Cancel", comment: ""), inViewController: self, withConfirmAction: { text in
                    reportWithReason(.Other(text))
                }, cancelAction: nil)
            }
            reportAlertController.addAction(otherReasonAction)

            let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            reportAlertController.addAction(cancelAction)

            self.presentViewController(reportAlertController, animated: true, completion: nil)
        }
        alertController.addAction(reportAction)

        let blockAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Block", comment: ""), style: .Destructive) { action -> Void in
            // TODO: blockAction
        }
        alertController.addAction(blockAction)

        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
    */

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        guard let identifier = segue.identifier else {
            return
        }
    }
}

// MARK: UICollectionView

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    enum ProfileSection: Int {
        case Header = 0
        case Footer
        case Master
        case Learning
        case SeparationLine
        case SocialAccount
        case SeparationLine2
        case Feeds
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 8
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {

        case ProfileSection.Header.rawValue:
            return 1
        case ProfileSection.Footer.rawValue:
            return 1

        case ProfileSection.SeparationLine.rawValue:
            let needSeparationLine = profileUser?.needSeparationLine ?? false
            return needSeparationLine ? 1 : 0

        case ProfileSection.SeparationLine2.rawValue:
            return 1

        case ProfileSection.Feeds.rawValue:
            return 1

        default:
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case ProfileSection.Header.rawValue:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(headerCellIdentifier, forIndexPath: indexPath) as! ProfileHeaderCell

            if let profileUser = profileUser {
                switch profileUser {
                case .DiscoveredUserType(let discoveredUser):
                    cell.configureWithDiscoveredUser(discoveredUser)
                case .UserType(let user):
                    cell.configureWithUser(user)
                }
            }

            cell.updatePrettyColorAction = { [weak self] prettyColor in
                self?.customNavigationBar.tintColor = prettyColor

                let textAttributes = [
                    NSForegroundColorAttributeName: prettyColor,
                    NSFontAttributeName: UIFont.navigationBarTitleFont()
                ]
                self?.customNavigationBar.titleTextAttributes = textAttributes
            }

            return cell

        case ProfileSection.Footer.rawValue:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(footerCellIdentifier, forIndexPath: indexPath) as! ProfileFooterCell

            if let profileUser = profileUser {
                cell.configureWithProfileUser(profileUser, introduction: introductionText)
            }

            return cell

        case ProfileSection.SeparationLine.rawValue:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(separationLineCellIdentifier, forIndexPath: indexPath) as! ProfileSeparationLineCell
            return cell
            
        case ProfileSection.SeparationLine2.rawValue:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(separationLineCellIdentifier, forIndexPath: indexPath) as! ProfileSeparationLineCell
            return cell

        default:
            break;
        }
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {

            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: sectionHeaderIdentifier, forIndexPath: indexPath) as! ProfileSectionHeaderReusableView

            switch indexPath.section {
            default:
                header.titleLabel.text = ""
            }

            if profileUserIsMe {

            } else {
                header.accessoryImageView.hidden = true
            }

            return header

        } else {
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: sectionFooterIdentifier, forIndexPath: indexPath) 
            return footer
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        switch section {

        case ProfileSection.Header.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: sectionBottomEdgeInset, right: 0)

        case ProfileSection.Footer.rawValue:
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            
        case ProfileSection.SeparationLine.rawValue:
            return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)

        case ProfileSection.SeparationLine2.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        default:
            return UIEdgeInsetsZero
        }
    }

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {

        switch indexPath.section {

        case ProfileSection.Header.rawValue:

            return CGSize(width: collectionViewWidth, height: collectionViewWidth * profileAvatarAspectRatio)
        case ProfileSection.Footer.rawValue:
            return CGSize(width: collectionViewWidth, height: footerCellHeight)

        case ProfileSection.SeparationLine.rawValue:
            return CGSize(width: collectionViewWidth, height: 1)

        case ProfileSection.SeparationLine2.rawValue:
            return CGSize(width: collectionViewWidth, height: 1)

        case ProfileSection.Feeds.rawValue:
            return CGSize(width: collectionViewWidth, height: 40)

        default:
            return CGSizeZero
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let profileUser = profileUser else {
            return CGSizeZero
        }

        let normalHeight: CGFloat = 40

        if profileUser.isMe {

            switch section {

            case ProfileSection.Master.rawValue:
                return CGSizeMake(collectionViewWidth, normalHeight)

            case ProfileSection.Learning.rawValue:
                return CGSizeMake(collectionViewWidth, normalHeight)

            default:
                return CGSizeZero
            }

        } else {
            switch section {
                
            default:
                return CGSizeZero
            }
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension ProfileViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        guard let profileUser = profileUser else {
//            return
//        }
//        
//        if let _ = profileUser.username {
//            
//        } else {
//            if profileuser.userId != YepUserDefaults.userID.value {
//                return
//            }
//        }
//        
//        let progress = -(scrollView.contentOffset.y)/100
//        
//        shareView.center = CGPoint(x: view.frame.width/2.0, y: 150.0 + 50*progress)
//        
//        shareView.updateWithProgress(progress)
        
//        if scrollView.contentOffset.y < -300 {
//            YepAlert.alert(title: "Hello", message: "My name is NIX.\nHow are you?", dismissTitle: "I'm fine.", inViewController: self, withDismissAction: nil)
//        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}
