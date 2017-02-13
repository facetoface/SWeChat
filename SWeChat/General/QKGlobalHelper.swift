//
//  QKGlobalHelper.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import UIKit

func dispatch_async_safely_to_main_queue(_ block: @escaping ()->()) {
    dispatch_async_safely_to_queue(DispatchQueue.main, block)
}

func dispatch_async_safely_to_queue(_ queue: DispatchQueue, _ block: @escaping ()->()) {
    if queue === DispatchQueue.main && Thread.isMainThread {
        block()
    } else {
        queue.async {
            block()
        }
    }
}

func QKAlertView_show(_ title: String, message: String? = nil) {
    var theMessage = ""
    if message != nil {
        theMessage = message!
    }
    let alertView = UIAlertView.init(title: title, message: theMessage, delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "好的")
    alertView.show()
}

func printLog<T> (_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
