//
//  QKMessageCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKMessageCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var unreadNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = 24
        self.unreadNumberLabel.layer.masksToBounds = true
        self.unreadNumberLabel.layer.cornerRadius = 9
    }

    func setCellContent(_ model: MessageModel){
        self.avatarImageView.qk_setImageWithURLString(model.middleImageURL, placeholderImage: model.messageFromType.placeHolderImage)
        self.unreadNumberLabel.text = model.unreadNumber! > 99 ? "99+" : String(model.unreadNumber!)
        self.lastMessageLabel.text = model.latestMessage!
        self.dateLabel.text = model.dateString!
        self.nameLabel.text = model.nickname
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
