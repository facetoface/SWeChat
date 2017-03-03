//
//  QKChatEmotionInputView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Dollar

private let itemHeight: CGFloat = 50
private let kOneGroupCount = 23
private let kNumberOfOneRow: CGFloat = 8

protocol ChatEmotionInputViewDelegate {
    func chatEmotionInputViewDidTapCell(_ cell: QKChatEmotionCell)
    func chatEmotionInputViewDidTapBackspace(_ cell: QKChatEmotionCell)
    func chatEmotionInputViewDidTapSend()
}

class QKChatEmotionInputView: UIView {

    @IBOutlet weak var emotionPageControl: UIPageControl!
    @IBOutlet weak var sendButton: UIButton! {
        didSet{
            sendButton.layer.borderColor = UIColor.lightGray.cgColor
            sendButton.layer.borderWidth = 0.5
            sendButton.layer.cornerRadius = 3
            sendButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var listCollectionView: QKChatEmotionScollView!
    fileprivate var groupDataSouce = [[EmotionModel]]()
    fileprivate var emotionDataSouce = [EmotionModel]()
    internal var delegate: ChatEmotionInputViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }

    func initialize() {
        
    }
    
    override func awakeFromNib() {
        
        self.isUserInteractionEnabled = true
        
        let itemWidth = (UIScreen.ts_width - 10*2)/kNumberOfOneRow
        let padding = (UIScreen.ts_width - kNumberOfOneRow * itemWidth) / 2.0
        let paddingLeft = padding
        let paddingRight = UIScreen.ts_width - paddingLeft - itemWidth*kNumberOfOneRow
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        
        self.listCollectionView.collectionViewLayout = layout
        self.listCollectionView.register(QKChatEmotionCell.ts_Nib(), forCellWithReuseIdentifier: QKChatEmotionCell.identifer)
        self.listCollectionView.isPagingEnabled = true
        self.listCollectionView.emotionScrollDelegate = self
        
        guard let emojiArray = NSArray(contentsOfFile: QKConfig.ExpressionPlist!) else {
            return
        }
        for data in emojiArray {
            let model = EmotionModel.init(fromDictionary: data as! NSDictionary)
            self.emotionDataSouce.append(model)
        }
        self.groupDataSouce = $.chunk(self.emotionDataSouce, size: kOneGroupCount)
        self.emotionPageControl.numberOfPages = self.groupDataSouce.count
        self.listCollectionView.dataSource = self
        self.listCollectionView.delegate = self
        self.listCollectionView.reloadData()

    }
    
    @IBAction func sendTaped(_ sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.chatEmotionInputViewDidTapSend()
        }
    }
    
    fileprivate func emotionForIndexPath(_ indexPath: IndexPath) ->EmotionModel? {
        let page = indexPath.section
        var index = page * kOneGroupCount + indexPath.row
        
        let ip = index / kOneGroupCount
        let ii = index % kOneGroupCount
        let reIndex = (ii % 3) * Int(kNumberOfOneRow) + (ii / 3)
        index = reIndex + ip * kOneGroupCount
        if index < self.emotionDataSouce.count {
            return self.emotionDataSouce[index]
        } else {
            return nil
        }
    }
}

extension QKChatEmotionInputView: ChatEmotionScollViewDelegate {
    func emotionScrollViewDidTapCell(_ cell: QKChatEmotionCell) {
        guard let delegate = self.delegate else {
            return
        }
        
        if cell.isDelete {
            delegate.chatEmotionInputViewDidTapBackspace(cell)
        } else {
            delegate.chatEmotionInputViewDidTapCell(cell)
        }
    }
}

extension QKChatEmotionInputView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension QKChatEmotionInputView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QKChatEmotionCell.identifer, for: indexPath) as! QKChatEmotionCell
        if indexPath.row == kOneGroupCount {
            cell.setDeleteCellContent()
        } else {
            cell.setCellContent(self.emotionForIndexPath(indexPath))
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupDataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kOneGroupCount + 1
    }
}

extension QKChatEmotionInputView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.listCollectionView.ts_width
        self.emotionPageControl.currentPage = Int(self.listCollectionView.contentOffset.x / pageWidth)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listCollectionView.hidenMagnifierView()
        self.listCollectionView.endBackspaceTimer()
    }
    
}

extension QKChatEmotionInputView: UIInputViewAudioFeedback {
    internal var enableInputClicksWhenVisible: Bool {
        get { return true }
    }
}
