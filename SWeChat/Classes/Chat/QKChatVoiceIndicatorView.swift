//
//  QKChatVoiceIndicatorView.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/10.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKChatVoiceIndicatorView: UIView {
    
    @IBOutlet weak var centerView: UIView! {
        didSet {
            centerView.layer.cornerRadius = 4
            centerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var noteLabel: UILabel! {
        didSet {
            noteLabel.layer.cornerRadius = 2
            noteLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var cancelImageView: UIImageView!
    @IBOutlet weak var signalValueImageView: UIImageView!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var tooShotPromptImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initContent() {
        
    }
    
}

extension QKChatVoiceIndicatorView {
    func recording() {
        self.isHidden = false
        self.cancelImageView.isHidden = true
        self.tooShotPromptImageView.isHidden = true
        self.recordingView.isHidden = false
        self.noteLabel.backgroundColor = UIColor.clear
        self.noteLabel.text = "手指上滑,取消发送"
    }
    
    func signalValueChagned(_ value: CGFloat) {
        
    }
    
    func slideToCanceRecord() {
        self.isHidden = false
        self.cancelImageView.isHidden = false
        self.tooShotPromptImageView.isHidden = true
        self.recordingView.isHidden = true
        self.noteLabel.backgroundColor = UIColor.init(ts_hexString: "#9c3638")
        self.noteLabel.text = "松开手指,取消发送"
    }
    
    func messageTooShort()  {
        self.isHidden = false
        self.cancelImageView.isHidden = true
        self.tooShotPromptImageView.isHidden = false
        self.recordingView.isHidden = true
        self.noteLabel.backgroundColor = UIColor.clear
        self.noteLabel.text = "说话时间太短"
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { 
            self.endRecord()
        }
    }
    
    func endRecord() {
        self.isHidden = true
    }
    
    func updateMetersValue(_ value: Float)  {
        var index = Int(round(value))
        index = index > 7 ? 7 : index
        index = index < 0 ? 0 : index
        
        let array = [
        TSAsset.RecordingSignal001.image,
        TSAsset.RecordingSignal002.image,
        TSAsset.RecordingSignal003.image,
        TSAsset.RecordingSignal004.image,
        TSAsset.RecordingSignal005.image,
        TSAsset.RecordingSignal006.image,
        TSAsset.RecordingSignal007.image,
        TSAsset.RecordingSignal008.image,
        ]
        
        self.signalValueImageView.image = array.get(index: index)
    }
    
    
}
