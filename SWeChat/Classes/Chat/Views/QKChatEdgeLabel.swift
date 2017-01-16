//
//  QKChatEdgeLabel.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/16.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKChatEdgeLabel: UILabel {

    var inserts: UIEdgeInsets = UIEdgeInsetsMake(0, 7,  0, 7)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, inserts))
    }

}
