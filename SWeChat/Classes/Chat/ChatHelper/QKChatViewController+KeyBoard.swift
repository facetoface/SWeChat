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
            strongSelf.keyboardControl(notification, isShowing: true)
        })
        
        notificationCenter.ts_addObserver(self, name: NSNotification.Name.UIKeyboardDidShow.rawValue, object: nil, handler: { observer, notification in
            if let keyboardSize = (notification.userInfo? [UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                _ = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        })
        
        notificationCenter.ts_addObserver(self, name: NSNotification.Name.UIKeyboardWillShow.rawValue, object: nil, handler: {
            [weak self] observer, notification in
            guard let strongSelf = self else { return }
            strongSelf.keyboardControl(notification, isShowing: false)
        })
        
        notificationCenter.ts_addObserver(self, name: NSNotification.Name.UIKeyboardDidHide.rawValue, object: nil, handler: {
            observer, notification in
        })
        
        
    }
    
    func keyboardControl(_ notification: Notification, isShowing: Bool)  {
        let keyboardType = self.chatActionBarView.keyboardType
        if keyboardType == .emotion || keyboardType == .share {
            return
        }
        var useInfo = notification.userInfo!
        let keyboardRect = (useInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (useInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions.init(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (useInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        
        self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstraint?.update(offset: -heightOffset)
        UIView.animate(withDuration: duration!,
                       delay: 0,
                       options: options,
                       animations: {
                        self.view.layoutIfNeeded()
                        if isShowing {
                            self.listTableView.scrollToBottom(false)
                        }
        }) { bool  in
            
        }
        
    }
    
    func appropriateKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var keyboardHeight: CGFloat = 0.0
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            keyboardHeight = min(endFrame.width, endFrame.height)
        }
        
        if notification.name == Notification.Name("") {
            keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            keyboardHeight -= self.tabBarController!.tabBar.frame.height
        }
        return keyboardHeight
    }
    
    func appropriateKeyboardHeight() -> CGFloat {
        var height = self.view.bounds.size.height
        height -= self.keyboardHeightConstraint!.constant
        guard height > 0 else {
            return 0
        }
        return height
    }
    
    fileprivate func hideCustomKeyboard() {
        let heightOffset: CGFloat = 0
        self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstraint?.update(offset: -heightOffset)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIViewAnimationOptions(), animations: {
                        self.view.layoutIfNeeded()
        }, completion: {
            bool in
        })
    }
    
    func hideAllKeyboard()  {
        self.hideCustomKeyboard()
        self.chatActionBarView.registerKeyboard()
    }
}

extension QKChatViewController: QKChatActionBarViewDelegate {
    func chatActionBarRecordVoiceHideKeyboard() {
        self.hideCustomKeyboard()
    }
    func chatActionBarShowEmotionKeyboard() {
        let heightOffset = self.emotionInputeView.ts_height
        self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstraint?.update(offset: -heightOffset)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIViewAnimationOptions(),
                       animations: {
                        self.emotionInputeView.snp.updateConstraints{
                            make in
                            make.top.equalTo(self.chatActionBarView.snp.bottom).offset(0)
                        }
                        
                        self.shareMoreView.snp.updateConstraints({make in
                            make.top.equalTo(self.chatActionBarView.snp.bottom).offset(self.view.ts_height)
                        })
                        self.view.layoutIfNeeded()
                        self.listTableView.scrollBottomToLastRow()
                        
        }, completion: {
            bool in
        })
    }
    
    func chatActionBarShowShareKeyboard() {
        let heightOffset = self.shareMoreView.ts_height
        self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstraint?.update(offset: -heightOffset)
        
        self.shareMoreView.ts_top = self.view.ts_height
        self.view.bringSubview(toFront: self.shareMoreView)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIViewAnimationOptions(),
                       animations: { 
                        self.shareMoreView.snp.updateConstraints({ make  in
                            make.top.equalTo(self.chatActionBarView.snp.bottom).offset(0)
                        })
                        self.view.layoutIfNeeded()
                        self.listTableView.scrollBottomToLastRow()
        }) { bool in
            
        }
    }
}
