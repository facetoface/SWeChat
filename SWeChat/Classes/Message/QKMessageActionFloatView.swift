//
//  QKMessageActionFloatView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

private let kActionViewWidth: CGFloat = 140
private let kActionViewHeight: CGFloat = 190
private let kActionButtonHeight: CGFloat = 44
private let kFirstButtonY: CGFloat = 12

enum ActionFloatViewItemType: Int {
    case groupChat = 0, addFriend, scan, payement
}

protocol ActionFloatViewDelegate: class {
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType)
}


class QKMessageActionFloatView: UIView {
    
    weak var delegate: ActionFloatViewDelegate?
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initContent()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    fileprivate func initContent() {
        self.backgroundColor = UIColor.clear
        
        let actionImages = [
            TSAsset.Contacts_add_newmessage.image,
            TSAsset.Barbuttonicon_add_cube.image,
            TSAsset.Contacts_add_scan.image,
            TSAsset.Receipt_payment_icon.image,
            ]
        
        let  actionTitles = [
            "发起群聊",
            "添加朋友",
            "扫一扫",
            "收付款",
            ]
        
        let containterView : UIView = UIView()
        containterView.backgroundColor = UIColor.clear
        self.addSubview(containterView)
        containterView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(3)
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.equalTo(kActionViewWidth)
            make.height.equalTo(kActionViewHeight)
        }
        
        let stretchInsets = UIEdgeInsetsMake(14, 6, 6, 34)
        let bubbleMaskImage = TSAsset.MessageRightTopBg.image.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        let bgImageView: UIImageView = UIImageView(image: bubbleMaskImage)
        containterView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(containterView)
        }
        
        var yValue = kFirstButtonY
        for index  in 0 ..< actionImages.count  {
            let itemButton: UIButton = UIButton(type: .custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 17)
            itemButton.setTitleColor(UIColor.white, for: .normal)
            itemButton.setTitleColor(UIColor.white, for: .highlighted)
            itemButton.setTitle(actionTitles.get(index: index), for: .normal)
            itemButton.setTitle(actionTitles.get(index: index), for: .highlighted)
            itemButton.setImage(actionImages.get(index: index), for: .normal)
            itemButton.setImage(actionImages.get(index: index), for: .highlighted)
            itemButton.addTarget(self, action: #selector(QKMessageActionFloatView.buttonTaped(_:)), for: UIControlEvents.touchUpInside)
            itemButton.contentHorizontalAlignment = .left
            itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            itemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
            itemButton.tag = index
            containterView.addSubview(itemButton)
            
            itemButton.snp.makeConstraints({ (make) -> Void in
                make.top.equalTo(containterView.snp.top).offset(yValue)
                make.right.equalTo(containterView.snp.right)
                make.width.equalTo(containterView.snp.width)
                make.height.equalTo(kActionButtonHeight)
            })
            yValue += kActionButtonHeight

        }
        
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx.event.subscribe { _ in
            self.hide(true)
        }.addDisposableTo(self.disposeBag)
        
        self.isHidden = true
        
    }
    
    func buttonTaped(_ sender: UIButton){
        guard let delegate = self.delegate else {
            self.hide(true)
            return
        }
        let type = ActionFloatViewItemType(rawValue: sender.tag)!
        delegate.floatViewTapItemIndex(type)
        self.hide(true)
    }
    
    func hide(_ hide: Bool)  {
        if hide {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.2, animations: { 
                self.alpha = 0.0
            }, completion:{ finish in
                self.isHidden = true
                self.alpha = 1.0
                
            })
        } else {
            self.alpha = 1.0
            self.isHidden = false
        }
        
    }
}
