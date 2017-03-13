//
//  QKChatViewController+HandleData.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension QKChatViewController {
    
    func chatSendText() {
        dispatch_async_safely_to_main_queue({
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let textView = strongSelf.chatActionBarView.inputTextView else {
                return
            }
            
            guard textView.text.ts_length < 1000 else {
                QKProgressHUD.qk_showWarningWithStatus("超出字数限制")
                return
            }
            
            let text = textView.text.trimmingCharacters(in: CharacterSet.whitespaces)
            if text.length == 0 {
                QKProgressHUD.qk_showWarningWithStatus("不能发送空白消息")
                return
            }
            let string = strongSelf.chatActionBarView.inputTextView.text
            let model = QKChatModel.init(text: string!)
            strongSelf.itemDataSouce.append(model)
            let insertIndexPath = IndexPath.init(row: strongSelf.itemDataSouce.count - 1, section: 0)
            strongSelf.listTableView.insertRowsAtBottom([insertIndexPath])
            textView.text = ""
            
            strongSelf.textViewDidChange(strongSelf.chatActionBarView.inputTextView)
            
            
        })
    }
    
    func chatSendImage(_ imageModel: ChatImageModel) {
        dispatch_async_safely_to_main_queue {
            [weak self ] in
            guard let strongSelf = self else { return }
            let model = QKChatModel.init(imageModel: imageModel)
            strongSelf.itemDataSouce.append(model)
            let insertIndexPath = IndexPath.init(row: strongSelf.itemDataSouce.count - 1, section: 0)
            strongSelf.listTableView.insertRowsAtBottom([insertIndexPath])
        }
    }
    
    func chatSendVoice(_ audioModel: ChatAudioModel) {
        dispatch_async_safely_to_main_queue {
            [weak self] in
            guard let strongSelf = self else { return }
            let model = QKChatModel.init(audioModel: audioModel)
            strongSelf.itemDataSouce.append(model)
            let insertIndexPath = IndexPath.init(row: strongSelf.itemDataSouce.count - 1, section: 0)
            strongSelf.listTableView.insertRowsAtBottom([insertIndexPath])
        }
    }
    
}
