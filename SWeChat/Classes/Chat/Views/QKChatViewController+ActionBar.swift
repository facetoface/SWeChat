//
//  QKChatViewController+ActionBar.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension QKChatViewController {
    
    func setupActionBarButtonInerAction() {
        let voiceButton: QKChatButton = self.chatActionBarView.voiceButton
        let recordButton: UIButton = self.chatActionBarView.recordButton
        let emotionButton: QKChatButton = self.chatActionBarView.emotionButton
        let shareButton: QKChatButton = self.chatActionBarView.shareButton
        
        voiceButton.rx.tap.subscribe {
           [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            let showRecording = strongSelf.chatActionBarView.recordButton.isHidden
            if showRecording {
                strongSelf.chatActionBarView.showRecording()
                voiceButton.emotionSwiftVoiceButtonUI(showKeyboard: true)
                strongSelf.controlExpandableInputView(showExpandable: false)
            } else {
                strongSelf.chatActionBarView.showTyingKeyboard()
                voiceButton.emotionSwiftVoiceButtonUI(showKeyboard: false)
                strongSelf.controlExpandableInputView(showExpandable: true)
            }
        }.addDisposableTo(self.disposeBag)
        
        var finishRecording: Bool = true
        let longTap = UILongPressGestureRecognizer()
        recordButton.addGestureRecognizer(longTap)
        longTap.rx.event.subscribe { [weak self] _ in
            guard let strongSelf = self else { return }
            if longTap.state == .began {
                finishRecording = true
                strongSelf.voiceIndicatorView.recording()
                
            }
        }
    }
    
    func controlExpandableInputView(showExpandable: Bool) {
        let textView = self.chatActionBarView.inputTextView
        let currentTextHeight = self.chatActionBarView.inputTextViewCurrentHeight
        UIView.animate(withDuration: 0.3) { 
            () -> Void in
            let textHeihgt = showExpandable ? currentTextHeight : kChatActionBarOriginalHeight
            self.chatActionBarView.snp.updateConstraints{ (make) -> Void in
                make.height.equalTo(textHeihgt)
            }
            self.view.layoutIfNeeded()
            self.listTableView.scrollBottomToLastRow()
            textView?.contentOffset = CGPoint.zero
        }
    }
}
