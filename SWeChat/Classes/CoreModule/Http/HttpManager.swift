//
//  HttpManager.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/28.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

public typealias qk_parameters = [String : AnyObject]
public typealias SuccessClosure = (AnyObject) -> Void
public typealias FailureClosure = (NSError) -> Void

class HttpManager: NSObject {
    class var shareInstance : HttpManager {
        struct Static {
            static let instance : HttpManager = HttpManager()
        }
        return Static.instance
    }
    
    fileprivate override init() {
        super.init()
    }
}
