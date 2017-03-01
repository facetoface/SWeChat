//
//  QKApplicationManger.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/27.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class QKApplicationManger: NSObject {
    static func applicationConfigInit() {
        self.initNavigationBar()
        self.initNotifications()
        QKProgressHUD.qk_initHUD()
        
    }
    
    static func initNavigationBar() {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        UINavigationBar.appearance().barTintColor = UIColor.barTintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = true
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 19),
            NSForegroundColorAttributeName: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    static func  initNotifications() {
        let settings = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}
