//
//  QKChatButton+UI.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension UIButton {
    
    func emotionSwiftVoiceButtonUI(showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(TSAsset.Tool_keyboard_1.image, for: UIControlState())
            self.setImage(TSAsset.Tool_keyboard_2.image, for: .highlighted)
        } else {
            self.setImage(TSAsset.Tool_voice_1.image, for: UIControlState())
            self.setImage(TSAsset.Tool_voice_2.image, for: .highlighted)
        }
    }
    
    func replaceEmotionButtonUI(showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(TSAsset.Tool_keyboard_1.image, for: UIControlState())
            self.setImage(TSAsset.Tool_keyboard_2.image, for: .highlighted)
        } else {
            self.setImage(TSAsset.Tool_emotion_1.image, for: UIControlState())
            self.setImage(TSAsset.Tool_emotion_2.image, for: .highlighted)
        }
    }
    
    func replaceRecordButtonUI(isRecording: Bool) {
        if isRecording {
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#C6C7CB"), forState: .normal)
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#F3F4F8"), forState: .highlighted)
        } else {
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#F3F4F8"), forState: .normal)
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#C6c7CB"), forState: .highlighted)
        }
    }
    
}
