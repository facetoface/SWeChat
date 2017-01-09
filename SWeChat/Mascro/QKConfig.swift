//
//  QKConfig.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation

class QKConfig {
    static let testUserID = "wx1234skjksmsjdfwe234"
    static let ExpressionBundle = Bundle(url: Bundle.main.url(forResource: "Expression", withExtension: "bundle")!)
    static let ExpressionBundleName = "Expression.bundle"
    static let ExpressionPlist = Bundle.main.path(forResource: "Expression", ofType: "plist")
}
