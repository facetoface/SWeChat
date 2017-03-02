//
//  QKChatViewController+SubViews.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/19.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Foundation

private let kCustomKeyboardHeight: CGFloat = 216

extension QKChatViewController {
    
    func setupSubViews(_ delegate: UITextViewDelegate) {
        self.setupActionBar(delegate)
        self.initListTableView()
        self.setupKeyboardInputView()
        self.setupVoiceIndicatorView()
    }
    
    fileprivate func initListTableView() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        self.listTableView.addGestureRecognizer(tap)
        tap.rx.event.subscribe{[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.hideAllKeyboard()
        }.addDisposableTo(self.disposeBag)
        
        self.view.addSubview(self.listTableView)
        self.listTableView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.chatActionBarView.snp.top)
        }
        
    }
    
    
    fileprivate func setupActionBar(_ delegate: UITextViewDelegate) {
        self.chatActionBarView = UIView.ts_viewFromNib(QKChatActionBarView.self)
        self.chatActionBarView.delegate = self
        self.view.addSubview(self.chatActionBarView)
        self.chatActionBarView.snp.makeConstraints { [weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            strongSelf.actionBarPaddingBottomConstraint = make.bottom.equalTo(strongSelf.view.snp.bottom).constraint
            make.height.equalTo(kChatActionBarOriginalHeight)
        }
    }
    
    fileprivate func setupKeyboardInputView() {
        self.emotionInputeView = UIView.ts_viewFromNib(QKChatEmotionInputView.self)
        self.emotionInputeView.delegate = self
        self.view.addSubview(self.emotionInputeView)
        self.emotionInputeView.snp.makeConstraints { [weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.top.equalTo(strongSelf.chatActionBarView.snp.bottom).offset(0)
            make.height.equalTo(kCustomKeyboardHeight)
        }
        self.shareMoreView = UIView.ts_viewFromNib(QKChatShareMoreView.self)
        self.shareMoreView!.delegate = self
        self.view.addSubview(self.shareMoreView)
        self.shareMoreView.snp.makeConstraints { [weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.top.equalTo(strongSelf.chatActionBarView.snp.bottom).offset(0)
            make.height.equalTo(kCustomKeyboardHeight)
        }
        
    }
    
    fileprivate func setupVoiceIndicatorView() {
        self.voiceIndicatorView = UIView.ts_viewFromNib(QKChatVoiceIndicatorView.self)
        self.view.addSubview(self.voiceIndicatorView)
        self.voiceIndicatorView.snp.makeConstraints { [weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.view.snp.top).offset(100)
            make.left.equalTo(strongSelf.view.snp.left)
            make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-100)
            make.right.equalTo(strongSelf.view.snp.right)
        }
        self.voiceIndicatorView.isHidden = true
    }
    
}
