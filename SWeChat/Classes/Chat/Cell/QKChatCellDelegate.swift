//
//  QKChatCellDelegate.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/11.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation

@objc protocol QKChatCellDelegate: class {

    @objc optional func cellDidTapped(_ cell: QKChatBaseCell)
    
    func cellDidTapedAvatarImage(_ cell: QKChatBaseCell)
    
    func cellDidTapedImageView(_ cell: QKChatBaseCell)
    
    func cellDidTapedLink(_ cell: QKChatBaseCell, linkSting: String)
    
    func cellDidTapedPhone(_ cell: QKChatBaseCell, phoneString: String)
    
    func cellDidTapedVoiceButton(_ cell: QKChatBaseCell, isPlayingVoice: Bool)
}
