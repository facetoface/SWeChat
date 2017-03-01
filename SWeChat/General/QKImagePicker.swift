//
//  QKImagePicker.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/22.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

public extension UIViewController {
    func qk_presentImagePickerController(maxNumberOfSelections: Int, select:((_ assest: PHAsset) -> Void)?, deselect:((_ asset: PHAsset) -> Void)?, cancel: (([PHAsset]) -> Void)?, finish: (([PHAsset]) -> Void)?, completion: (() -> Void)?) {
        let viewController = BSImagePickerViewController()
        viewController.maxNumberOfSelections = maxNumberOfSelections
        viewController.albumButton.tintColor = UIColor.white
        viewController.cancelButton.tintColor = UIColor.white
        viewController.doneButton.tintColor = UIColor.white
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        self.bs_presentImagePickerController(viewController, animated: true, select: select, deselect: deselect, cancel: cancel, finish: finish, completion: {
        
        })
    }
}

