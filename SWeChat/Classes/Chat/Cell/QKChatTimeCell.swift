//
//  QKChatTimeCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/16.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

private let kChatTimeLabelMaxWidth: CGFloat = UIScreen.ts_width - 30*2
private let kChatTimeLabelPaddingLeft: CGFloat = 6
private let kChatTimeLabelPaddingTop: CGFloat = 3
private let kChatTimeLabelMarginTop: CGFloat = 10
class QKChatTimeCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.layer.cornerRadius = 4
            timeLabel.layer.masksToBounds = true
            timeLabel.textColor = UIColor.white
            timeLabel.backgroundColor = UIColor.init(red: 190/255,
                                                     green: 190/255,
                                                     blue: 190/255,
                                                     alpha: 0.6)
        }
    }
    var model: QKChatModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func setCellContent(_ model: QKChatModel)  {
        self.model = model
        self.timeLabel.text = String.init(format: "%@", model.messageContent!)
        
    }
    
    override func layoutSubviews() {
        guard let message = self.model?.messageContent else {
            return
        }
        self.timeLabel.ts_setFrameWithString(message, width: kChatTimeLabelMaxWidth)
        self.timeLabel.width = self.timeLabel.width + kChatTimeLabelPaddingLeft * 2
        self.timeLabel.height = self.timeLabel.height + kChatTimeLabelMarginTop * 2
        self.timeLabel.top = kChatTimeLabelMarginTop
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    class func heightForCell() -> CGFloat {
        return 40
    }
}
