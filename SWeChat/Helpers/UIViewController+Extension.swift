//
//  UIViewController+Extension.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {

    class func initFromNib() -> UIViewController {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter")
            return UIViewController()
        }
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }
    
    public static var topViewController: UIViewController? {
        var presentedVc = UIApplication.shared.keyWindow?.rootViewController
        while let pVc = presentedVc?.presentedViewController {
            presentedVc = pVc
        }
        if presentedVc == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return presentedVc
    }
    
    fileprivate func qk_pushViewController(_ viewController: UIViewController, animated: Bool, hidenTabbar: Bool) {
        viewController.hidesBottomBarWhenPushed = hidenTabbar
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func qk_pushAndHideTabbar(_ viewController: UIViewController, animated: Bool) {
        self.qk_pushViewController(viewController, animated: true, hidenTabbar: true)
    }
    
    public func qk_presentViewController(_ viewController: UIViewController, completion: (()->Void)?) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: completion)

    }
}
