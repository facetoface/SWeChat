//
//  QKConstactCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/4.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKConstactCell: UITableViewCell {
 
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func setCellContent(_ model: QKContactModel){
    self.avatarImageView.qk_setImageWithURLString(model.avatarSmallURL, placeholderImage: TSAsset.Icon_avatar.image)
        self.usernameLabel.text = model.chineseName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
