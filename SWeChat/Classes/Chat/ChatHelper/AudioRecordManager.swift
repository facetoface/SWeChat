//
//  AudioRecordManger.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import AVFoundation
import TSVoiceConverter

let kAudioFileTypeWav = "wav"
let kAudioFileTypeAmr = "amr"
let AudioRecordInstance = AudioRecordManager.shareInstance

private let TempWavRecordPath = AudioFilesManager.wavPathWithName("wav_temp_record")
private let TempAmrFilePath = AudioFilesManager.amrPathWithName("amr_temp_record")

class AudioRecordManager: NSObject {
    var recorder: AVAudioRecorder!
    var operationQueue: OperationQueue!
    weak var delegate: RecordAudioDelegate?
    
    fileprivate var startTime: CFTimeInterval!
    fileprivate var endTimer: CFTimeInterval!
    fileprivate var audioTimeInterval: NSNumber!
    fileprivate var isFinishiRecord: Bool = true
    fileprivate var isCancelRecord: Bool = false
    
    class var shareInstance : AudioRecordManager {
        struct Static {
            static let instance : AudioRecordManager = AudioRecordManager()
        }
        return Static.instance
    }
    
    fileprivate override init() {
        self.operationQueue = OperationQueue()
        super.init()
    }
    
    func checkPermissionAndSetupRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryRecord, with: .duckOthers)
            do {
                try session.setActive(true)
                session.requestRecordPermission{allowed in
                    if !allowed {
                    QKAlertView_show("无法访问您的麦克风", message: "请到设置 -> 隐私 -> 麦克风, 打开访问权限")
                    }}
            } catch let error as NSError {
                log.error("Could not activate the audio session:\(error)")
                QKAlertView_show("无法访问您的麦克风", message: error.localizedFailureReason!)
            }
        } catch let error as NSError {
            log.error("An error occured in setting the audio, session category. Error = \(error)")
            QKAlertView_show("无法访问您的麦克风", message: error.localizedFailureReason!)
        }
    }
    
    func checkHeadphones() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    log.info("headphones are plugged in")
                    break
                } else {
                    log.info("headphones are ")
                }
            }
        }
    }
    
    func startRecord() {
        self.isCancelRecord = false
        self.startTime = CACurrentMediaTime()
        do {
            let recordSettings:[String : AnyObject] = [
                AVLinearPCMBitDepthKey: NSNumber.init(value: 16 as Int32),
                AVFormatIDKey: NSNumber.init(value: kAudioFormatLinearPCM as UInt32),
                AVNumberOfChannelsKey: NSNumber.init(value: 1 as Int32),
                AVSampleRateKey: NSNumber.init(value: 8000.0 as Float),
            ]

            self.recorder = try AVAudioRecorder.init(url: TempWavRecordPath, settings: recordSettings)
            self.recorder.delegate = self
            self.recorder.isMeteringEnabled = true
            self.recorder.prepareToRecord()
            
        } catch let error as NSError {
            self.recorder = nil
            log.error("error localizedDescription: \(error.localizedDescription)")
            QKAlertView_show("初始化录音失败", message: error.localizedDescription)
        }
        self.perform(#selector(AudioRecordManager.readyStartRecord), with: self, afterDelay: 0.0)
    }
    
    func readyStartRecord() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch let error as NSError {
            log.error("setActive fail: \(error)")
            QKAlertView_show("无法访问您的麦克风", message: error.localizedDescription)
            return
        }
        
        do {
            try audioSession.setActive(true)
        } catch let error as NSError {
            log.error("setActive fail:\(error)")
            QKAlertView_show("无法访问您的麦克风", message: error.localizedDescription)
            return
        }
        self.recorder.record()
        let operation = BlockOperation()
        operation.addExecutionBlock(updateMeters)
        self.operationQueue.addOperation(operation)
    }
    
    func updateMeters() {
        guard let recorder = self.recorder else {
            return
        }
        repeat {
            recorder.updateMeters()
            self.audioTimeInterval = NSNumber.init(value: NSNumber.init(value: recorder.currentTime as Double).floatValue as Float)
            let avaragePower = recorder.averagePower(forChannel: 0)
            let lowPassResults = pow(10, (0.05 * avaragePower)) * 10
            dispatch_async_safely_to_main_queue {
                self.delegate?.audioRecordUpdateMetra(lowPassResults)
            }
            if self.audioTimeInterval.int32Value > 60 {
                self.stopRecord()
            }
            Thread.sleep(forTimeInterval: 0.05)
        } while (recorder.isRecording)
    }
    
    func stopRecord() {
        self.isFinishiRecord = true
        self.isCancelRecord = false
        self.endTimer = CACurrentMediaTime()
        if (self.endTimer - self.startTime) < 0.5 {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(AudioRecordManager.readyStartRecord), object: self)
            dispatch_async_safely_to_main_queue {
                self.delegate?.audioRecordTooShort()
            }
        }   else {
            self.audioTimeInterval = NSNumber.init(value: NSNumber.init(value: self.recorder.currentTime as Double).int32Value as Int32)
            if self.audioTimeInterval.int32Value < 1 {
                self.perform(#selector(AudioRecordManager.readyStartRecord), with: self, afterDelay: 0.4)
            } else {
                self.readyStartRecord()
            }
        }
        
        self.operationQueue.cancelAllOperations()
    }
    
    func cancelRecord() {
        self.isCancelRecord = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(AudioRecordManager.readyStartRecord), object: self)
        self.isFinishiRecord = false
        self.recorder.stop()
        self.recorder.deleteRecording()
        self.recorder = nil
        self.delegate?.audioRecordCanceled()
    }
    
    func readyStopRecord() {
        self.recorder.stop()
        self.recorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, with: .notifyOthersOnDeactivation)
            
        } catch let error as NSError {
            log.error("error:\(error)")
        }
    }
    
    func deleteRecordFiles() {
        AudioFilesManager.deletAllRecordingFiles()
    }
    
}

extension AudioRecordManager : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag && self.isFinishiRecord {
            if TSVoiceConverter.convertWavToAmr(TempWavRecordPath.path, amrSavePath: TempAmrFilePath.path) {
                guard let amrAudioData = try? Data.init(contentsOf: TempAmrFilePath) else {
                    self.delegate?.audioRecordFailed()
                    return
                }
                let fileName = amrAudioData.ts_md5String
                let wavDestinationURL = AudioFilesManager.amrPathWithName(fileName)
                AudioFilesManager.renameFile(TempWavRecordPath, destinationPath: wavDestinationURL)
                self.delegate?.audioRecordFinish(amrAudioData, recordTime: self.audioTimeInterval.floatValue, fileHash: fileName)
            } else {
                self.delegate?.audioRecordFailed()
            }
        } else {
            if !self.isCancelRecord {
                self.delegate?.audioRecordFailed()
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recoder: AVAudioRecorder, error: Error?) {
        if let e = error {
            log.error("\(e.localizedDescription)")
            self.delegate?.audioRecordFailed()
        }
    }
}

