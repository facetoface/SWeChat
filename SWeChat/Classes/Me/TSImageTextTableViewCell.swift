//
//  TSImageTextTableViewCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/4.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class TSImageTextTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.accessoryType = .disclosureIndicator;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
