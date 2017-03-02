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
                AudioRecordInstance.startRecord()
                recordButton.replaceRecordButtonUI(isRecording: true)
            } else if longTap.state == .changed {
                let point = longTap.location(in: self!.voiceIndicatorView)
                if strongSelf.voiceIndicatorView.point(inside: point, with: nil) {
                    strongSelf.voiceIndicatorView.slideToCanceRecord()
                    finishRecording = false
                } else {
                    strongSelf.voiceIndicatorView.recording()
                    finishRecording = true
                }
                
            } else if longTap.state == .ended {
                if finishRecording {
                    AudioRecordInstance.stopRecord()
                } else {
                    AudioRecordInstance.cancelRecord()
                }
                strongSelf.voiceIndicatorView.endRecord()
                recordButton.replaceRecordButtonUI(isRecording: false)
            }
            }.addDisposableTo(self.disposeBag)
        
        emotionButton.rx.tap.subscribe {
            [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.chatActionBarView.resetButtonUI()
            emotionButton.replaceEmotionButtonUI(showKeyboard: !emotionButton.showTypingKeyboard)
            if emotionButton.showTypingKeyboard {
                strongSelf.chatActionBarView.showTyingKeyboard()
            } else {
                strongSelf.chatActionBarView.showEmotionKeyboard()
            }
            strongSelf.controlExpandableInputView(showExpandable: true)
            }.addDisposableTo(self.disposeBag)
        
        shareButton.rx.tap.subscribe {
            [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.chatActionBarView.resetButtonUI()
            if shareButton.showTypingKeyboard {
                strongSelf.chatActionBarView.showTyingKeyboard()
            } else {
                strongSelf.chatActionBarView.showShareKeyboard()
            }
            strongSelf.controlExpandableInputView(showExpandable: true)
            }.addDisposableTo(self.disposeBag)
        
        let textView: UITextView = self.chatActionBarView.inputTextView
        let tap = UITapGestureRecognizer()
        textView.addGestureRecognizer(tap)
        tap.rx.event.subscribe {
            textView.inputView = nil
            textView.becomeFirstResponder()
            textView.reloadInputViews()
            }.addDisposableTo(self.disposeBag)
        
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
