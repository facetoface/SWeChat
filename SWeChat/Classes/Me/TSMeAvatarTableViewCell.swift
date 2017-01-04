//
//  TSMeAvatarTableViewCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/4.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class TSMeAvatarTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var wechatIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.accessoryType = .disclosureIndicator;
        self.avatarImageView.layer.masksToBounds = true;
        self.avatarImageView.layer.cornerRadius = 32.5;
        self.avatarImageView.layer.borderWidth = 0.5;
        self.avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
