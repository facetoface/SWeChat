//
//  QKChatButton.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKChatButton: UIButton {

    var showTypingKeyboard: Bool
    required init?(coder aDecoder: NSCoder) {
        self.showTypingKeyboard = true
        super.init(coder: aDecoder)!
    }

}
