//
//  QKChatShareMoreCollectionViewCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/10.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKChatShareMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.itemButton.setBackgroundImage(TSAsset.Sharemore_other_HL.image, for: .highlighted)
            } else {
                self.itemButton.setBackgroundImage(TSAsset.Sharemore_other.image, for: UIControlState())
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
