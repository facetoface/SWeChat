//
//  QKChatViewController+Interaction.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

extension QKChatViewController: ChatShareMoreViewDelegate {
    func chatShareMoreViewPhotoTaped() {
        self.qk_presentImagePickerController(maxNumberOfSelections: 1, select: { (asset: PHAsset) in
            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: {[weak self] (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
            guard let strongSelf = self else { return }
            if let image = assets.get(index: 0).getUIImage() {
                strongSelf.resizeAndSendImage(image)
            }
            }, completion: { () -> Void in
                print("completion")
        })
    }
    
    func chatShareMoreViewCameraTaped() {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == .notDetermined {
            self.checkCameraPermission()
        } else if authStatus == .restricted || authStatus == .denied {
            QKAlertView_show("无法访问您的相机", message: "请到设置 -> 隐私 -> 相机 ，打开访问权限" )
        } else if authStatus == .authorized {
            
        }
    }
    
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
            if !granted {
                QKAlertView_show("无法访问您的相机", message: "请到设置 -> 隐私 -> 相机，代开访问权限")
            }
        }
    }
    
    func openCamera()  {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func resizeAndSendImage(_ theImage: UIImage) {
        let originalImage = UIImage.ts_fixImageOrientation(theImage)
        let storeKey = "send_image" + String.init(format: "%f", Date.milliseconds)
        let thumbSize = QKChatConfig.getThumbImageSize(originalImage.size)
        
        guard let thumbNail = originalImage.ts_resize(thumbSize) else {
            return
        }
        QKImageFilesManger.storeImage(thumbNail, key: storeKey) { 
            [weak self ] in
            guard let strongSelf = self else { return }
            let sendImageModel = ChatImageModel()
            sendImageModel.imageHeight = originalImage.size.height
            sendImageModel.imageWidth = originalImage.size.width
            sendImageModel.localStoreName = storeKey
            strongSelf.chatSendImage(sendImageModel)
            
            HttpManager.uploadSingleImage(originalImage, success: { model in
                sendImageModel.imageHeight = model.originalHeight
                sendImageModel.imageWidth = model.originalWidth
                sendImageModel.thumbURL = model.thumbURL
                sendImageModel.originalURL = model.originalURL
                sendImageModel.imageId = String.init(describing: model.imageId)
                
                let tempStorePath = URL.init(string: QKImageFilesManger.cachePathForKey(storeKey)!)
                let targetStorePath = URL.init(string: QKImageFilesManger.cachePathForKey(sendImageModel.thumbURL!)!)
                QKImageFilesManger.renameFile(tempStorePath!, destinationPath: targetStorePath!)
                
            }, failure: {
                
            })
            
        }
    }
    
   
}

extension QKChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType = info[UIImagePickerControllerMediaType] as? NSString else {
            return
        }
        if mediaType.isEqual(to: kUTTypeImage as String) {
            guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            if picker.sourceType == .camera {
                self.resizeAndSendImage(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension QKChatViewController: RecordAudioDelegate {
    func audioRecordUpdateMetra(_ metra: Float) {
        self.voiceIndicatorView.updateMetersValue(metra)
    }
    
    func audioRecordTooShort() {
        self.voiceIndicatorView.messageTooShort()
    }
    
    func audioRecordFailed() {
        QKAlertView_show("录音失败,请重试")
    }
    
    func audioRecordCanceled() {
        
    }
    
    func audioRecordFinish(_ uploadAmrData: Data, recordTime: Float, fileHash: String) {
        self.voiceIndicatorView.endRecord()
        
        let audioModel = ChatAudioModel()
        audioModel.keyHash = fileHash
        audioModel.audioURL = ""
        audioModel.duration = recordTime
        self.chatSendVoice(audioModel)
     
        HttpManager.uploadAudio(uploadAmrData, recordTime: String(recordTime), success: { model in
            audioModel.keyHash = model.keyHash
            audioModel.audioURL = model.audioURL
            audioModel.duration = recordTime
        }, failure: {
        })
        
    }
}

extension QKChatViewController: PlayAudioDelegate {
    func auidoPlayStart() {
        
    }
    
    func audioPlayFinished() {
        self.currentVoiceCell.resetVoiceAnimation()
    }
    
    func audioPlayInterruption() {
        self.currentVoiceCell.resetVoiceAnimation()

    }
    
    func audioPlayFailed() {
        self.currentVoiceCell.resetVoiceAnimation()
    }
}

extension QKChatViewController: ChatEmotionInputViewDelegate {
    
    func chatEmotionInputViewDidTapSend() {
        self.chatSendText()
    }
    
    func chatEmotionInputViewDidTapCell(_ cell: QKChatEmotionCell) {
        var string = self.chatActionBarView.inputTextView.text
        string = string! + cell.emotionModel!.text
        self.chatActionBarView.inputTextView.text = string
    }
    
    func chatEmotionInputViewDidTapBackspace(_ cell: QKChatEmotionCell) {
        self.chatActionBarView.inputTextView.deleteBackward()
    }
    
}

extension QKChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textView.contentSize.height
        guard contentHeight < kChatActionBarTextViewMaxHeight else {
            return
        }
        self.chatActionBarView.inputTextViewCurrentHeight = contentHeight + 17
        self.controlExpandableInputView(showExpandable: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.chatActionBarView.inputTextViewCallKeyboard()
        
        UIView.setAnimationsEnabled(false)
        let range = NSMakeRange(textView.text.length - 1, 1)
        textView.scrollRangeToVisible(range)
        UIView.setAnimationsEnabled(true)
        return true
    }
}


