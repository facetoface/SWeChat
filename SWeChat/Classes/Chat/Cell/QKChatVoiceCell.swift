//
//  QKChatVoiceCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/11.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

private let kChatVoiceBubbleTopTransparentGapValue: CGFloat = 7
private let kChatVoicePlayingMarginLeft: CGFloat = 16
private let kChatVoiceMaxWidth: CGFloat = 200


class QKChatVoiceCell: QKChatBaseCell {

    @IBOutlet weak var listenVoiceButton: UIButton! {
        didSet {
            listenVoiceButton.imageView!.animationDuration = 1
            listenVoiceButton.isSelected = false
        }
    }
    @IBOutlet weak var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setCellContent(_ model: QKChatModel) {
        super.setCellContent(model)
        self.durationLabel.text = String.init(format: "%zd\"", Int(model.audioModel!.duration!))
        let stretchImage = model.fromMe ? TSAsset.SenderTextNodeBkg.image : TSAsset.ReceiverTextNodeBkg.image
        let bubbleImage = stretchImage.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        self.listenVoiceButton.setBackgroundImage(bubbleImage, for: UIControlState())
        
        let stretchImageHL = model.fromMe ? TSAsset.SenderTextNodeBkgHL.image : TSAsset.ReceiverTextNodeBkgHL.image
        let bubbleImageHL = stretchImageHL.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        self.listenVoiceButton.setBackgroundImage(bubbleImageHL, for: .highlighted)
        
        let voiceImage = model.fromMe ? TSAsset.SenderVoiceNodePlaying.image : TSAsset.ReceiverVoiceNodePlaying.image
        self.listenVoiceButton.setImage(voiceImage, for: UIControlState())
        
        self.listenVoiceButton.imageEdgeInsets = model.fromMe ? UIEdgeInsetsMake(-kChatBubbleBottomTransparentHeight, 0, 0, kChatVoicePlayingMarginLeft) : UIEdgeInsetsMake(-kChatBubbleBottomTransparentHeight, kChatVoicePlayingMarginLeft, 0, 0)
        
        self.listenVoiceButton.contentHorizontalAlignment = model.fromMe ? .right : .left
        
        if model.fromMe {
            self.listenVoiceButton.imageView!.animationImages = [
            TSAsset.SenderVoiceNodePlaying001.image,
            TSAsset.SenderVoiceNodePlaying002.image,
            TSAsset.SenderVoiceNodePlaying003.image,
            ]
        } else {
            self.listenVoiceButton.imageView!.animationImages = [
            TSAsset.ReceiverVoiceNodePlaying001.image,
            TSAsset.ReceiverVoiceNodePlaying002.image,
            TSAsset.ReceiverVoiceNodePlaying003.image,
            ]
        }
    }

    @IBAction func playingTaped(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.listenVoiceButton.imageView!.startAnimating()
        } else {
            self.listenVoiceButton.imageView!.stopAnimating()
        }
        guard let delegate = self.delegate else {
            return
        }
        delegate.cellDidTapedVoiceButton(self, isPlayingVoice: sender.isSelected)
    }
    
    func resetVoiceAnimation() {
        self.listenVoiceButton.imageView!.stopAnimating()
        self.listenVoiceButton.isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        guard let duration = model.audioModel?.duration, duration > 0 else {
            return
        }
        let voiceLength = 70 + 130 * CGFloat(duration/60)
        
        self.listenVoiceButton.width = min(voiceLength, kChatVoiceMaxWidth)
        self.listenVoiceButton.height = kChatBubbleImageViewHeight
        self.listenVoiceButton.top = self.nicknameLabel.bottom - kChatVoiceBubbleTopTransparentGapValue
        
        if model.fromMe {
            self.listenVoiceButton.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - self.listenVoiceButton.width
            self.durationLabel.left = self.listenVoiceButton.width - self.durationLabel.width
            self.durationLabel.textAlignment = .right
        } else {
            self.listenVoiceButton.left = kChatBubbleLeft
            self.durationLabel.left = self.listenVoiceButton.right
            self.durationLabel.textAlignment = .left
        }
        self.durationLabel.height = self.listenVoiceButton.height
        self.durationLabel.top = self.listenVoiceButton.top
    }
    
    class func layoutHeight(_ model: QKChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        if model.audioModel?.duration == 0 {
            return 0
        }
        var height: CGFloat = 0
        height += kChatAvatarMarginTop + kChatBubblePaddingBottom
        height += kChatBubbleImageViewHeight
        model.cellHeight = height
        return model.cellHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
