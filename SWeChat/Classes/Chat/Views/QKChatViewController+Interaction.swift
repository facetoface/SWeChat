//
//  QKChatViewController+Interaction.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension QKChatViewController: ChatEmotionInputViewDelegate {
    
    func chatEmotionInputViewDidTapSend() {
        self.chatSendText()
    }
    
    func chatEmotionInputViewDidTapCell(_ cell: QKChatEmotionCell) {
        var string = self.chatActionBarView.inputTextView.text
        string = string! + cell.emotionModel!.text
        self.chatActionBarView.inputTextView.text = string
    }
    
    func chatEmotionInputViewDidTapBackspace(_ cell: QKChatEmotionCell) {
        self.chatActionBarView.inputTextView.deleteBackward()
    }
    
}

extension QKChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textView.contentSize.height
        guard contentHeight < kChatActionBarTextViewMaxHeight else {
            return
        }
        self.chatActionBarView.inputTextViewCurrentHeight = contentHeight + 17
        
    }
}


