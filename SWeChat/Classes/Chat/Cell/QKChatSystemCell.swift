//
//  QKChatSystemCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/16.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

private let kChatInfoFont: UIFont = UIFont.systemFont(ofSize: 13)
private let kChatInfoLabelMaxWidth: CGFloat = UIScreen.ts_width - 40 * 2
private let kChatInfoLabelPaddingLeft: CGFloat = 8
private let kChatInfoLabelPaddingTop: CGFloat = 4
private let kChatInfoLableMarginTop: CGFloat = 3
private let kChatInfoLabelMarginBottom: CGFloat = 10

class QKChatSystemCell: UITableViewCell {

    @IBOutlet weak var infomationLabel: QKChatEdgeLabel! {
        didSet {
            infomationLabel.font = kChatInfoFont
            infomationLabel.inserts = UIEdgeInsets(
                top: 0,
                left: kChatTextMarginLeft,
                bottom: 0,
                right: kChatInfoLabelPaddingLeft)
            infomationLabel.layer.cornerRadius = 4
            infomationLabel.layer.masksToBounds = true
            infomationLabel.font = kChatInfoFont
            infomationLabel.textColor = UIColor.white
            infomationLabel.backgroundColor = UIColor.init(red: 190/255,
                                                           green: 190/255,
                                                           blue: 190/255,
                                                           alpha: 0.6)
        }
    }
    
    var model: QKChatModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setCellContent(_ model: QKChatModel) {
        self.model = model
        self.infomationLabel.text = model.messageContent
    }
    
    override func layoutSubviews() {
        guard let model = self.model else {
            return
        }
        
        self.infomationLabel.ts_setFrameWithString(model.messageContent!, width: kChatInfoLabelMaxWidth)
        self.infomationLabel.width = self.infomationLabel.width + kChatInfoLabelPaddingLeft * 2
        self.infomationLabel.height = self.infomationLabel.height + kChatInfoLableMarginTop * 2
        self.infomationLabel.left = (UIScreen.ts_width - self.infomationLabel.width) / 2
        self.infomationLabel.top = kChatInfoLableMarginTop
        
    }
    
    class func layoutHeight(_ model: QKChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        var height: CGFloat = 0
        height += kChatInfoLableMarginTop + kChatInfoLableMarginTop
        let stringHeight: CGFloat = model.messageContent!.ts_heightWithConstrainedWidth(kChatInfoLabelMaxWidth, font: kChatInfoFont)
        height += stringHeight + kChatInfoLabelPaddingTop * 2
        model.cellHeight = height
        return height
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
