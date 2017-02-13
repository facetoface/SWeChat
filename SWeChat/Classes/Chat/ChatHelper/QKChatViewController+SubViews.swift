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
        
    }
    
}
