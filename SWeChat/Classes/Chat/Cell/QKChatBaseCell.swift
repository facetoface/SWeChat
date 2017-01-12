//
//  QKChatBaseCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/11.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import RxSwift

private let kChatNicknameLabelHeight: CGFloat = 20
let kChatAvatarMarginLeft: CGFloat = 10
let kChatAvatarMarginTop: CGFloat = 0
let kChatAvatarWidth: CGFloat = 40


class QKChatBaseCell: UITableViewCell {
    weak var delegate: QKChatCellDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.backgroundColor = UIColor.clear
            avatarImageView.width = kChatAvatarWidth
            avatarImageView.height = kChatAvatarWidth
        }
    }
    @IBOutlet weak var nicknameLabel: UILabel! {
        didSet {
            nicknameLabel.font = UIFont.systemFont(ofSize: 11)
            nicknameLabel.textColor = UIColor.darkGray
        }
    }
    var model: QKChatModel?
    let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        self.avatarImageView.image = nil
        self.nicknameLabel.text = nil
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer()
        self.avatarImageView.addGestureRecognizer(tap)
        tap.rx.event.subscribe{[weak self] _ in
            if let strongSelf = self {
                guard let delegate = strongSelf.delegate else {
                    return
                }
                delegate.cellDidTapedImageView(strongSelf)
            }
            
            }.addDisposableTo(self.disposeBag)
    }
    
    
    func setCellContent(_ model: QKChatModel)  {
        self.model = model
        if self.model!.fromMe {
            let avatarURL = "http://ww3.sinaimg.cn/thumbnail/6a011e49jw1f1e87gcr14j20ks0ksdgr.jpg"
            self.avatarImageView.qk_setImageWithURLString(avatarURL, placeholderImage: TSAsset.Icon_avatar.image)
        } else {
            let avaterURL = "http://ww2.sinaimg.cn/large/6a011e49jw1f1j01nj8g6j204f04ft8r.jpg"
            self.avatarImageView.qk_setImageWithURLString(avaterURL, placeholderImage: TSAsset.Icon_avatar.image)
        }
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        guard let model = self.model else {
            return
        }
        if model.fromMe {
            self.nicknameLabel.height = 0
            self.avatarImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth
        } else {
            self.nicknameLabel.height = 0
            self.avatarImageView.left = kChatAvatarMarginLeft
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
