//
//  QKChatEmotionScollView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

protocol ChatEmotionScollViewDelegate {
    func emotionScrollViewDidTapCell(_ cell: QKChatEmotionCell)
}

class QKChatEmotionScollView: UICollectionView {
    
    fileprivate var touchBeganTime: TimeInterval = 0
    fileprivate var touchMoved: Bool = false
    fileprivate var magnifierImageView: UIImageView!
    fileprivate var magnifierContentImageView: UIImageView!
    fileprivate var backSpaceTimer: Timer!
    fileprivate weak var currentMagnifierCell: QKChatEmotionCell?
    
    var emotionScrollDelegate: ChatEmotionScollViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    func initialize() {
        self.magnifierImageView = UIImageView(image: TSAsset.Emoticon_keyboard_magnifier.image)
        self.magnifierContentImageView = UIImageView()
        self.magnifierContentImageView.size = CGSize(width: 40, height: 40)
        self.magnifierContentImageView.centerX = self.magnifierImageView.width/2
        self.magnifierImageView.addSubview(self.magnifierContentImageView)
        self.magnifierImageView.isHidden = true
        self.addSubview(self.magnifierImageView)
    }
    
    override func awakeFromNib() {
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = false
        self.isUserInteractionEnabled = true
        self.canCancelContentTouches = false
        self.isMultipleTouchEnabled = false
        self.scrollsToTop = false
    }
    
    deinit {
        self.endBackspaceTimer()
    }
    
    func startBackspaceTimer() {
        self.endBackspaceTimer()
        self.backSpaceTimer = Timer.ts_every(0.1, { [weak self] in
            if self!.currentMagnifierCell!.isDelete {
                UIDevice.current.playInputClick()
                self!.emotionScrollDelegate?.emotionScrollViewDidTapCell(self!.currentMagnifierCell!)
            }
            
        })
        RunLoop.main.add(self.backSpaceTimer, forMode: .commonModes)
    }
    
    
    func endBackspaceTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(QKChatEmotionScollView.startBackspaceTimer), object: nil)
        if self.backSpaceTimer != nil {
            self.backSpaceTimer.invalidate()
            self.backSpaceTimer = nil
        }
    }
    
    
    func cellForTouches(_ touches: Set<UITouch>) -> QKChatEmotionCell? {
        let touch = touches.first as UITouch!
        let point = touch?.location(in: self)
        let indexPath = self.indexPathForItem(at: point!)
        guard let newIndexPath = indexPath else {
            return nil
        }
        let cell: QKChatEmotionCell = self.cellForItem(at: newIndexPath) as! QKChatEmotionCell
        return cell
    }
    
    func hidenMagnifierView() {
        self.magnifierImageView.isHidden = true
    }
    
    func showMagnifierForCell(_ cell: QKChatEmotionCell) {
        if cell.isDelete || cell.emotionImageView.image == nil {
            self.hidenMagnifierView()
            return
        }
        let rect: CGRect = cell.convert(cell.bounds, to: self)
        self.magnifierImageView.center = CGPoint(x: rect.midX, y: self.magnifierImageView.center.y)
        self.magnifierImageView.bottom = rect.maxY - 6
        self.magnifierImageView.isHidden = false
        
        self.magnifierContentImageView.image = cell.emotionImageView.image
        self.magnifierContentImageView.top = 20
        self.magnifierContentImageView.layer.removeAllAnimations()
        
        let duration: TimeInterval = 0.1
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.magnifierContentImageView.top = 3
            
        }) { (finished) in
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                self.magnifierContentImageView.top = 6
            }, completion: { finished in
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                    self.magnifierContentImageView.top = 5
                }, completion: nil)
            })
        }
        
    }
    
}

extension QKChatEmotionScollView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchMoved = false
        guard let cell = self.cellForTouches(touches) else {
            return
        }
        self.currentMagnifierCell = cell
        self.showMagnifierForCell(self.currentMagnifierCell!)
        if !cell.isDelete && cell.emotionImageView.image != nil {
            UIDevice.current.playInputClick()
        }
        
        if cell.isDelete {
            self.endBackspaceTimer()
            self.perform(#selector(QKChatEmotionScollView.startBackspaceTimer), with: nil, afterDelay: 0.5)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchMoved = true
        if self.currentMagnifierCell != nil && self.currentMagnifierCell!.isDelete {
            return
        }
        guard let cell = self.cellForTouches(touches) else {
            return
        }
        if cell != self.currentMagnifierCell {
            if !self.currentMagnifierCell!.isDelete && !cell.isDelete {
                self.currentMagnifierCell = cell
            }
            self.showMagnifierForCell(cell)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cell = self.cellForTouches(touches) else {
            self.endBackspaceTimer()
            return
        }
        let checkCell = !self.currentMagnifierCell!.isDelete && cell.emotionImageView.image != nil
        let checkMove = !self.touchMoved && cell.isDelete
        if checkCell || checkMove {
            self.emotionScrollDelegate?.emotionScrollViewDidTapCell(self.currentMagnifierCell!)
        }
        self.endBackspaceTimer()
        self.hidenMagnifierView()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hidenMagnifierView()
        self.endBackspaceTimer()
    }
}

