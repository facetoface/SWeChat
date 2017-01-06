//
//  QKChatActionBarView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

fileprivate let kChatActionBarOriginalHeight: CGFloat = 50
fileprivate let kChatActionBarTextViewMaxHeight: CGFloat = 120

protocol QKChatActionBarViewDelegate: class {
    
    func chatActionBarRecordVoiceHideKeyboard()
    
    func chatActionBarShowEmotionKeyboard()
    
    func chatActionBarShowShareKeyboard()
}

class QKChatActionBarView: UIView {

    enum ChatKeyboardType: Int {
        case `default`, text, emotion, share
    }
    
    var keyboardType: ChatKeyboardType? = .default
    weak var delegate: QKChatActionBarViewDelegate?
    var inputTextViewCurrentHeight: CGFloat = kChatActionBarOriginalHeight
    
 
}
