//
//  QKChatShareMoreView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import RxSwift
import Dollar

private let kLeftRightPadding: CGFloat = 15
private let kTopBottomPaddign: CGFloat = 10
private let kItemCountOfRow: CGFloat = 4

protocol ChatShareMoreViewDelegate: class {
    func chatShareMoreViewPhotoTaped()
    func chatShareMoreViewCameraTaped()
}
class QKChatShareMoreView: UIView {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: ChatShareMoreViewDelegate?
    internal let disposeBag = DisposeBag()
    
    fileprivate let itemDataSouce: [(name: String, iconImage: UIImage)] = [
        ("照片", TSAsset.Sharemore_pic.image),
        ("相机", TSAsset.Sharemore_video.image),
        ("小视频", TSAsset.Sharemore_sight.image),
        ("视频聊天", TSAsset.Sharemore_videovoip.image),
        ("红包", TSAsset.Sharemore_wallet.image),
        ("转账", TSAsset.SharemorePay.image),
        ("位置", TSAsset.Sharemore_location.image),
        ("收藏", TSAsset.Sharemore_myfav.image),
        ("个人名片", TSAsset.Sharemore_friendcard.image),
        ("语音输入", TSAsset.Sharemore_voiceinput.image),
        ("卡券", TSAsset.Sharemore_wallet.image),
        ]
    
    fileprivate var groupDataSouce = [[(name: String, iconImage: UIImage)]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    override func awakeFromNib() {
        let layout = QKFullyHorizontalFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(
            kTopBottomPaddign,
            kLeftRightPadding,
            kTopBottomPaddign,
            kLeftRightPadding)
        let itemSizeWidth = (UIScreen.ts_width - kLeftRightPadding * 2 - layout.minimumInteritemSpacing * (kItemCountOfRow - 1)) / kItemCountOfRow
        let itemSizeHeight = (self.collectionViewHeightConstraint.constant - kTopBottomPaddign*2) / 2
        layout.itemSize = CGSize(width: itemSizeWidth, height:itemSizeHeight)
        
        self.listCollectionView.collectionViewLayout = layout
        self.listCollectionView.register(QKChatShareMoreCollectionViewCell.ts_Nib(), forCellWithReuseIdentifier: QKChatShareMoreCollectionViewCell.identifer)
        self.listCollectionView.showsHorizontalScrollIndicator = false
        self.listCollectionView.isPagingEnabled = true
        
        self.groupDataSouce = $.chunk(self.itemDataSouce, size: Int(kItemCountOfRow)*2)
        self.pageControl.numberOfPages = self.groupDataSouce.count
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.listCollectionView.width = UIScreen.ts_width
    }
    
    func initialize() {
        
    }
    
}

extension QKChatShareMoreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                delegate.chatShareMoreViewPhotoTaped()
            } else if row == 1 {
                delegate.chatShareMoreViewCameraTaped()
            }
        }
    }
}

extension QKChatShareMoreView: UICollectionViewDataSource {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupDataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let subArray = self.groupDataSouce.get(index: section) else {
            return 0
        }
        return subArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QKChatShareMoreCollectionViewCell.identifer, for: indexPath) as! QKChatShareMoreCollectionViewCell
        guard let subArray = self.groupDataSouce.get(index: indexPath.section) else {
            return QKChatShareMoreCollectionViewCell()
        }
        if  let item = subArray.get(index: indexPath.row) {
            cell.itemLabel.text = item.name
            cell.itemButton.setImage(item.iconImage, for: .normal)
        }
        return cell
    }
}

extension QKChatShareMoreView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.listCollectionView.ts_width
        self.pageControl.currentPage = Int(self.listCollectionView.contentOffset.x / pageWidth)
    }
}
