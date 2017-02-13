//
//  QKProgressHUD.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import SVProgressHUD

class QKProgressHUD: NSObject {
    class func qk_initHUD() {
        SVProgressHUD.setBackgroundColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
    class func qk_showSuccessWithStatus(_ string: String) {
        self.QKProgressHUDShow(.success, status: string)
    }
    
    class func qk_showErrorWithObject(_ error: NSError) {
        self.QKProgressHUDShow(.errorObject, status: nil, error: error)
    }
    
    class func qk_showErrorWithStatus(_ string: String) {
     self.QKProgressHUDShow(.errorString, status: string)
    }
    
    class func qk_showWithStatus(_ string: String) {
        self.QKProgressHUDShow(.loading, status: string)
    }
    
    class func qk_showWarningWithStatus(_ string: String) {
        self.QKProgressHUDShow(.info, status: string)
    }
    
    class func qk_dismiss() {
        SVProgressHUD.dismiss()
    }
    
    fileprivate class func QKProgressHUDShow(_ type: HUDType, status: String? = nil, error: NSError? = nil) {
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
        break
        case .errorObject:
            guard let newError = error else {
                SVProgressHUD.showError(withStatus: "Error:出错啦")
                return
            }
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showError(withStatus: "Error:出错啦")
            } else {
                SVProgressHUD.showError(withStatus: error!.localizedFailureReason)
            }
            break
        case .errorString:
            SVProgressHUD.showError(withStatus: status)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
            break
        case .loading:
            SVProgressHUD.showInfo(withStatus: status)
            break
        }
        
    }
    
    fileprivate enum HUDType: Int {
        case success, errorObject, errorString, info, loading
    }
}
