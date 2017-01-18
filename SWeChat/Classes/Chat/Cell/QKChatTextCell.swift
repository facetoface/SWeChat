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
            contentLabel.highlightTapAction = ({[weak self] containerView, text, range, rect in
                self!.didTapRichLabelText(self!.contentLabel, textRange: range)
            })
        }
    }
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func debugYYlabel() -> YYTextDebugOption {
        let debugOptions = YYTextDebugOption()
        debugOptions.baselineColor = UIColor.red
        debugOptions.ctFrameBorderColor = UIColor.red
        debugOptions.ctLineFillColor = UIColor.init(red: 0.0, green: 0.463, blue: 1.0, alpha: 0.18)
        debugOptions.cgGlyphBorderColor = UIColor.init(red: 0.9971, green: 0.7368, blue: 1.0, alpha: 0.3609)
        return debugOptions
    }
    
    override func setCellContent(_ model: QKChatModel) {
        super.setCellContent(model)
        if let richeTextLinePositionModifier = model.richTextLinePositionModifier {
            self.contentLabel.linePositionModifier = richeTextLinePositionModifier
        }
        
        if let richTextLayout = model.richTextLayout {
            self.contentLabel.textLayout = richTextLayout
        }
        
        if let richeTextAttributedString = model.richTextAttributedString {
            self.contentLabel.attributedText = richeTextAttributedString
        }
        
        let stretchImage = model.fromMe ? TSAsset.SenderTextNodeBkg.image : TSAsset.ReceiverTextNodeBkg.image
        let bubbleImage = stretchImage.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        self.bubbleImageView.image = bubbleImage
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        self.contentLabel.size = model.richTextLayout!.textBoundingSize
        if model.fromMe {
            self.bubbleImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - max(self.contentLabel.width + kChatBubbleWidthBuffer, kChatBubbleImageViewWidth)
        } else {
            self.bubbleImageView.left = kChatBubbleLeft
        }
        
        self.bubbleImageView.width = max(self.contentLabel.width + kChatBubbleWidthBuffer, kChatBubbleImageViewWidth)
        self.bubbleImageView.height = max(self.contentLabel.height + kChatBubbleHeightBuffer + kChatBubbleBottomTransparentHeight, kChatBubbleImageViewHeight)
        self.bubbleImageView.top = self.nicknameLabel.bottom - kChatBubblePaddingTop
        self.contentLabel.top = self.bubbleImageView.top + kChatBubblePaddingTop
        self.contentLabel.left = self.bubbleImageView.left + kChatTextMarginLeft
        
    }
    
    class func layoutHeight(_ model: QKChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        let attributedString = QKChatTextParser.parseText(model.messageContent!, font: kChatTextFont)!
        model.richTextAttributedString = attributedString
        
        let modifier = QKYYTextLinePositionModifier(font: kChatTextFont)
        model.richTextLinePositionModifier = modifier
        
        let textContainer: YYTextContainer = YYTextContainer()
        textContainer.size = CGSize.init(width: kChatTextMaxWidth, height: CGFloat.greatestFiniteMagnitude)
        textContainer.linePositionModifier = modifier
        textContainer.maximumNumberOfRows = 0
        
        let textLayout = YYTextLayout.init(container: textContainer, text: attributedString)
        model.richTextLayout = textLayout
        
        var height: CGFloat = kChatAvatarMarginTop + kChatBubblePaddingBottom
        let stringHeight = modifier.heightForLineCount(Int(textLayout!.rowCount))
        
        height += max(stringHeight + kChatBubbleHeightBuffer + kChatBubbleBottomTransparentHeight, kChatBubbleImageViewHeight)
        model.cellHeight = height
        return model.cellHeight
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        if let phone: String = info[kChatTextKeyPhone] as? String {
            delegate?.cellDidTapedPhone(self, phoneString: phone)
        }
        if let URL: String = info[kChatTextKeyURL] as? String {
            delegate?.cellDidTapedLink(self, linkSting: URL)
        }
    }
    
}
