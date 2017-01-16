//
//  QKChatTextCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import YYText

private let kChatTextFont: UIFont = UIFont.systemFont(ofSize: 16)

class QKChatTextCell: QKChatBaseCell {

    @IBOutlet weak var contentLabel: YYLabel! {
        didSet {
            contentLabel.font = kChatTextFont
            contentLabel.numberOfLines = 0
            contentLabel.backgroundColor = UIColor.clear
            contentLabel.textVerticalAlignment = YYTextVerticalAlignment.top
            contentLabel.displaysAsynchronously = false
            contentLabel.ignoreCommonProperties = true
            contentLabel.highlightTapAction = ({
                [weak self] containerView, text, range, rect in
                
            })
        }
    }
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func didTapRichLabelText(_ label: YYLabel, textRange: NSRange) {
        let attributedString = label.textLayout!.text
        if textRange.location >= attributedString.length {
            return
        }
        guard let hightlight: YYTextHighlight = attributedString.yy_attribute(YYTextHighlightAttributeName, at: UInt(textRange.location)) as? YYTextHighlight else {
            return
        }
        guard let info = hightlight.userInfo, info.count > 0 else {
            return
        }
//        if let phone: String = info[kChatTextKeyPhone]
    }
    
}
