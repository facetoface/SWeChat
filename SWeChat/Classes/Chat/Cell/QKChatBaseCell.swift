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
        tap.rx.event.subscribe({[weak self] _ in
            if let strongSelf = self {
            }
            }
        ).addDisposableTo(self.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
