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
    
}
