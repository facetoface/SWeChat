//
//  UIBarButtonItem+Block.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//
import Foundation
import UIKit

public typealias ActionHandler = (Void) -> Void

public extension UIViewController {
    
    func leftBackAction(_ action: @escaping ActionHandler)  {
        self.ts_leftBackBarButton(TSAsset.Back_icon.image, action: action)
    }
    
    func leftBackToPrevious()  {
        self.leftBackBarButton(TSAsset.Back_icon.image, action: nil)
    }
    
    fileprivate func leftBackBarButton(_ backImage: UIImage, action: ActionHandler!) {
        guard self.navigationController != nil else {
            assert(false,"Your target ViewController doesn't have a UINavigationController")
            return
        }
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(backImage, for: UIControlState())
        button.frame = CGRect(x: 0,y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .left
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            [weak self] in
            if action != nil {
                action()
                return
            }
            
            if self!.navigationController!.viewControllers.count > 1 {
                self!.navigationController!.popViewController(animated: true)
            } else if (self?.presentingViewController != nil) {
                self!.dismiss(animated: true, completion: nil)
            }
            
            let barButton = UIBarButtonItem(customView: button)
            let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            gapItem.width = -7
            self?.navigationItem.leftBarButtonItems = [gapItem, barButton]
            
            
        })
    }
    
}

public extension UINavigationItem {
    
    func leftButtonAction(_ image: UIImage, action: @escaping ActionHandler)  {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .left
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
           action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7
        self.leftBarButtonItems = [gapItem, barButton]
    }
    
    func rightButtonAction(_ image: UIImage, action: @escaping ActionHandler)  {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width:40, height: 30)
        button.imageView!.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .right
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target:nil, action: nil)
        gapItem.width = -7
        self.rightBarButtonItems = [gapItem, barButton]
        
    }
}

open class ClosureWrapper: NSObject {
    let _callback : (Void) -> Void
    init(callback: @escaping (Void) -> Void) {
        _callback = callback
    }
    open func invoke() {
        _callback()
    }
}

var AssociatedClosure: UInt8 = 0
extension UIControl {
    fileprivate func ngl_addAction(forControlEvents events:UIControlEvents, withCallback callback: @escaping (Void) -> Void) {
        let wrapper = ClosureWrapper(callback: callback)
        addTarget(wrapper, action: #selector(ClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(wrapper, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
