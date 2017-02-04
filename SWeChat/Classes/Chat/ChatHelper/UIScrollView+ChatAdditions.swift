//
//  UIScrollView+ChatAdditions.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/20.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension UIScrollView {
    fileprivate struct AssociatedKeys {
        static var kKeyScrollViewVerticalIndicator = "_verticalScrollIndicator"
        static var kKeyScrollViewHorizontalIndicator = "_horizontalScrollIndicator"
    }

    public var isAtTop: Bool {
        get { return self.contentOffset.y == 0.0 ? true : false }
    }
    
    public var isAtBottom: Bool {
        get {
            let bottomOffset = self.contentSize.height - self.bounds.size.height
            return self.contentOffset.y == bottomOffset
        }
    }
    
    public var canScrollToBottom: Bool {
        get {
            return self.contentSize.height > self.bounds.size.height
        }
    }
    
    public var verticalScroller: UIView {
        get {
            if (objc_getAssociatedObject(self, #function) == nil) {
                objc_setAssociatedObject(self, #function, self.safeValueForKey(AssociatedKeys.kKeyScrollViewVerticalIndicator), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
            return objc_getAssociatedObject(self, #function) as! UIView
        }
    }
    
    public var horizontalScroller: UIView {
        get {
            if (objc_getAssociatedObject(self, #function) == nil) {
                objc_setAssociatedObject(self, #function, self.safeValueForKey(AssociatedKeys.kKeyScrollViewHorizontalIndicator), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
            return objc_getAssociatedObject(self, #function) as! UIView
        }
    }
    
    fileprivate func safeValueForKey(_ key: String) -> AnyObject {
        let instanceVariable: Ivar = class_getInstanceVariable(type(of: self), key.cString(using: String.Encoding.utf8)!)
        return object_getIvar(self, instanceVariable) as AnyObject
    }
    
    public func scrollToTopAnimated(_ animated: Bool) {
        if !self.isAtTop {
            let bottomOffset = CGPoint.zero
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    public func stopScrolling() {
        guard self.isDragging else {
            return
        }
        var offset = self.contentOffset
        offset.y -= 1.0
        self.setContentOffset(offset, animated: false)
        
        offset.y += 1.0
        self.setContentOffset(offset, animated: false)
    }
    
}
