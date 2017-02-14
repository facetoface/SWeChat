//
//  AudioDelegate.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/14.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation

protocol RecordAudioDelegate: class {

    func audioRecordUpdateMetra(_ metra: Float)
    
    func audioRecordTooShort()
    
    func audioRecordFailed()
    
    func audioRecordCanceled()
    
    func audioRecordFinish(_ uploadAmrData: Data, recordTime: Float, fileHash: String)
    
}

protocol PlayAudioDelegate: class {
    
    func auidoPlayStart()
    
    func audioPlayFinished()
    
    func audioPlayFailed()
    
    func audioPlayInterruption()
}

