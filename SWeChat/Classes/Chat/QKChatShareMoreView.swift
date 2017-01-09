//
//  QKChatShareMoreView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import RxSwift

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
        
    }
    
    
    func initialize() {
        
    }

}
