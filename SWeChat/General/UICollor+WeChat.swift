//
//  UICollor+WeChat.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/3.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    class var barTintColor: UIColor {
        get { return UIColor.init(ts_hexString: "#1A1A1A");}
    }
    
    class var tabbarSelectedTextColor: UIColor {
        get {return UIColor.init(ts_hexString:  "#68BB1E")}
    }
    
    class var viewBackgroundColor: UIColor {
        get {return UIColor.init(ts_hexString: "#E7EBEE")}
    }
}
