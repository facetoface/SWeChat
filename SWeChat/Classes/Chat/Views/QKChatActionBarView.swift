//
//  QKChatActionBarView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

let kChatActionBarOriginalHeight: CGFloat = 50
let kChatActionBarTextViewMaxHeight: CGFloat = 120

protocol QKChatActionBarViewDelegate: class {
    func chatActionBarRecordVoiceHideKeyboard()
    func chatActionBarShowEmotionKeyboard()
    func chatActionBarShowShareKeyboard()
}

class QKChatActionBarView: UIView {
    
    enum ChatKeyboardType: Int {
        case `default`, text, emotion, share
    }
    
    var keyboardType: ChatKeyboardType? = .default
    weak var delegate: QKChatActionBarViewDelegate?
    var inputTextViewCurrentHeight: CGFloat = kChatActionBarOriginalHeight
    
    @IBOutlet weak var inputTextView: UITextView! { didSet{
        inputTextView.font = UIFont.systemFont(ofSize: 17)
        inputTextView.layer.borderColor = UIColor.init(ts_hexString:"#DADADA").cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 5
        inputTextView.scrollsToTop = false
        inputTextView.textContainerInset = UIEdgeInsetsMake(7, 5, 5, 5)
        inputTextView.backgroundColor = UIColor.init(ts_hexString: "#f8fefb")
        inputTextView.returnKeyType = .send
        inputTextView.isHidden = false
        inputTextView.enablesReturnKeyAutomatically = true
        inputTextView.layoutManager.allowsNonContiguousLayout = false
        inputTextView.scrollsToTop = false
        }
    }
    @IBOutlet weak var voiceButton: QKChatButton!
    @IBOutlet weak var emotionButton: QKChatButton! { didSet{
        emotionButton.showTypingKeyboard = false
        }
    }
    
    @IBOutlet weak var shareButton: QKChatButton! { didSet{
        shareButton.showTypingKeyboard = false
        }
    }
    
    @IBOutlet weak var recordButton: UIButton! {
        didSet{
            recordButton.setBackgroundImage(UIImage.ts_imageWithColor(UIColor.init(ts_hexString: "#F3F4F8")), for: .normal)
            recordButton.setBackgroundImage(UIImage.ts_imageWithColor(UIColor.init(ts_hexString: "#C6C7CB")), for: .highlighted)
            recordButton.layer.borderColor = UIColor.init(ts_hexString: "#C2C3C7").cgColor
            recordButton.layer.borderWidth = 0.5
            recordButton.layer.cornerRadius = 0.5
            recordButton.layer.masksToBounds = true
            recordButton.isHidden = true
        }
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.initContent()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        initContent()
    }
    
    func initContent() {
        let topBorder = UIView()
        let bottomBorder = UIView()
        topBorder.backgroundColor = UIColor.init(ts_hexString: "#C2C3C7")
        bottomBorder.backgroundColor = UIColor.init(ts_hexString: "#C2C3C7")
        self.addSubview(topBorder)
        self.addSubview(bottomBorder)
        topBorder.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        bottomBorder.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    deinit {
        log.verbose("deinit")
    }
}

extension QKChatActionBarView {
    func resetButtonUI() {
        self.voiceButton.setImage(TSAsset.Tool_voice_1.image, for: .normal)
        self.voiceButton.setImage(TSAsset.Tool_voice_2.image, for: .highlighted)
        
        self.emotionButton.setImage(TSAsset.Tool_emotion_1.image, for: UIControlState())
        self.emotionButton.setImage(TSAsset.Tool_emotion_2.image, for: .highlighted)
        
        self.shareButton.setImage(TSAsset.Tool_share_1.image, for: UIControlState())
        self.shareButton.setImage(TSAsset.Tool_share_2.image, for: .highlighted)
    }
    
    func inputTextViewCallKeyboard() {
        self.keyboardType = .text
        self.inputTextView.isHidden = false
        self.recordButton.isHidden = true
        self.voiceButton.showTypingKeyboard = false
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    func showTyingKeyboard() {
        self.keyboardType = .text
        self.inputTextView.becomeFirstResponder()
        self.inputTextView.isHidden = false
        self.recordButton.isHidden = true
        self.voiceButton.showTypingKeyboard = false
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    func showRecording() {
        self.keyboardType = .default
        self.inputTextView.resignFirstResponder()
        self.inputTextView.isHidden = false
        if let delegate = self.delegate {
            delegate.chatActionBarRecordVoiceHideKeyboard()
        }
        self.recordButton.isHidden = false
        self.voiceButton.showTypingKeyboard = true
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    func showEmotionKeyboard() {
        self.keyboardType = .emotion
        self.inputTextView.resignFirstResponder()
        self.inputTextView.isHidden = false
        if let delegate = self.delegate {
            delegate.chatActionBarShowEmotionKeyboard()
        }
        self.recordButton.isHidden = true
        self.emotionButton.showTypingKeyboard = true
        self.shareButton.showTypingKeyboard = false
    }
    
    func showShareKeyboard() {
        self.keyboardType = .share
        self.inputTextView.resignFirstResponder()
        self.inputTextView.isHidden =  false
        if let delegate = self.delegate {
            delegate.chatActionBarShowShareKeyboard()
        }
        self.recordButton.isHidden = true
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = true
    }
    
    func registerKeyboard() {
        self.keyboardType = .default
        self.inputTextView.resignFirstResponder()
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    fileprivate func chageTextViewCursorColor(_ color: UIColor) {
        self.inputTextView.tintColor = color
        UIView.setAnimationsEnabled(false)
        self.inputTextView.resignFirstResponder()
        self.inputTextView.becomeFirstResponder()
        UIView.setAnimationsEnabled(true)
    }
    
    
}
