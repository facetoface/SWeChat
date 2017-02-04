//
//  QKChatViewController+KeyBoard.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/19.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension QKChatViewController {
    
    func keyboardControl() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.ts_addObserver(self, name: Notification.Name.UIKeyboardWillShow.rawValue, object: nil, handler: {[weak self] observer, notification in
            guard let strongSelf = self else { return }
            strongSelf.listTableView.scrollToBottom(false)
        
            
        })
    }
}

extension QKChatViewController: QKChatActionBarViewDelegate {
    func chatActionBarRecordVoiceHideKeyboard() {
        
    }
    func chatActionBarShowEmotionKeyboard() {
        
    }
    func chatActionBarShowShareKeyboard() {
        
    }
}
