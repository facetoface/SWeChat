//
//  QKUserManger.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/12.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON

let UserInstance =  QKUserManger.sharedInstance
private let kNickname    = "kTS_wechat_username"
private let kAvatar      = "kTS_wechat_avatar"
private let kAccessToken = "kTS_wechat_accessToken"
private let kUserId      = "kTS_wechat_userId"
private let kIsLogin     = "kTS_wechat_isLogin"
private let kLoginName   = "kTS_wechat_loginName"
private let kPassword    = "kTS_wechat_password"

class QKUserManger: NSObject {
    class var sharedInstance: QKUserManger {
        struct Static {
            static let instance: QKUserManger = QKUserManger()
        }
        return Static.instance
    }
    let QKKeychain = Keychain.init(service: "com.wechat.Hilen")
    var accessToken: String? {
        get {
            return UserDefaults.ts_stringForKey(kAccessToken, defaultValue: "it is my AccessToken")
        }
        set (newValue) {
            UserDefaults.ts_setString(kAccessToken, value: newValue)
        }
    }
    
    var nickName: String? {
        get {
            return UserDefaults.ts_stringForKey(kNickname, defaultValue: "")
        }
        set (newValue) {
            UserDefaults.ts_setString(kNickname, value: newValue)
        }
    }
    
    var avatar: String?
    var userId: String? {
        get {
            return UserDefaults.ts_stringForKey(kUserId, defaultValue: QKConfig.testUserID)
        }
        set (newValue) {
            UserDefaults.ts_setString(kUserId, value: newValue)
        }
    }
    var isLogin: Bool {
        get {
            return UserDefaults.ts_boolForKey(kIsLogin, defaultValue: false)
        }
        set (newValue) {
            UserDefaults.ts_setBool(kIsLogin, value: newValue)
        }
    }
    
    var loginName: String? {
        get {
            return QKKeychain[kLoginName] ?? ""
        }
        set (newValue) {
            QKKeychain[kLoginName] = newValue
        }
    }
    
    var password: String? {
        get {
            return QKKeychain[kPassword] ?? ""
        }
        set (newValue) {
            QKKeychain[kPassword] = newValue
        }
    }
    fileprivate override init() {
        super.init()
    }
    
    func readAllData() {
        self.nickName = UserDefaults.ts_stringForKey(kNickname, defaultValue: "")
        self.avatar = UserDefaults.ts_stringForKey(kAvatar, defaultValue: "")
        self.userId = UserDefaults.ts_stringForKey(kUserId, defaultValue: "")
        self.isLogin = UserDefaults.ts_boolForKey(kIsLogin, defaultValue: false)
        self.loginName = QKKeychain[kLoginName] ?? ""
        self.password = QKKeychain[kPassword] ?? ""
    }
    
    func userLoginSuccess(_ result: JSON) {
        self.loginName = result["username"].stringValue
        self.password = result["password"].stringValue
        self.nickName = result["nickname"].stringValue
        self.userId = result["user_id"].stringValue
        self.isLogin = true
    }
    
    func userLogout() {
        self.accessToken = ""
        self.loginName = ""
        self.password = ""
        self.nickName = ""
        self.userId = ""
        self.isLogin = false
    }
    
    func resetAccessToken(_ token: String) {
        UserDefaults.ts_setString(kAccessToken, value: token)
        if token.characters.count > 0 {
            print("token success")
        } else {
            self.userLogout()
        }
    }
    
}
