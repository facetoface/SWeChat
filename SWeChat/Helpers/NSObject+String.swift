//
//  NSObject+String.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{

    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last()! as String
    }
    
    class var identifer: String {
        return String(format: "%@_identifer",self.nameOfClass)
    }
    
}
