//
//  AudioPlayManager.swift
//  SWeChat
//
//  Created by ChiCo on 17/3/2.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire
import TSVoiceConverter

class AudioPlayManager: NSObject {
    fileprivate var audioPlayer: AVAudioPlayer?
    weak var delegate: PlayAudioDelegate?
    class var shareInstance : AudioPlayManager {
        struct Static {
            static let instance : AudioPlayManager = AudioPlayManager()
        }
        return Static.instance
    }
    
    fileprivate override init() {
        super.init()
        let notificationCenter = NotificationCenter.default
        notificationCenter.ts_addObserver(self, name: NSNotification.Name.UIDeviceProximityStateDidChange.rawValue, object: UIDevice.current) { (observer, notification) in
            if UIDevice.current.proximityState {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                } catch _ {}
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                } catch _ {}
            }
            
        }
    }
    
    func startPlaying(_ audioModel: ChatAudioModel) {
        if AVAudioSession.sharedInstance().category == AVAudioSessionCategoryRecord {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {}
        }
        guard let keyHash = audioModel.keyHash else {
            self.delegate?.audioPlayFailed()
            return
        }
        
        let wavFilePath = AudioFilesManager.wavPathWithName(keyHash)
        if FileManager.default.fileExists(atPath: wavFilePath.path) {
            self.playSoundWithPath(wavFilePath.path)
            return
        }
        
        let amrFilePath = AudioFilesManager.amrPathWithName(keyHash)
        if FileManager.default.fileExists(atPath: amrFilePath.path) {
            
        }
        
    }
    
    fileprivate func playSoundWithPath(_ path: String) {
        let fileData = try? Data.init(contentsOf: URL(fileURLWithPath: path))
        do {
            self.audioPlayer = try AVAudioPlayer.init(data: fileData!)
            guard let player = self.audioPlayer else {
                return
            }
            player.delegate = self
            player.prepareToPlay()
            guard let delegate = self.delegate else {
                log.error("delegate is nil")
                return
            }
            if player.play() {
                UIDevice.current.isProximityMonitoringEnabled = true
                delegate.auidoPlayStart()
            } else {
                delegate.audioPlayFailed()
            }
        } catch {
            self.destoryPlayer()
        }
    }
    
    func destoryPlayer() {
        self.stopPlayer()
    }
    
    func stopPlayer() {
        if self.audioPlayer == nil {
            return
        }
        self.audioPlayer!.delegate = nil
        self.audioPlayer!.stop()
        self.audioPlayer = nil
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    fileprivate func convertAmrToWavAndPlaySound(_ audioModel: ChatAudioModel) {
        if self.audioPlayer != nil {
            self.stopPlayer()
        }
        guard let fileName = audioModel.keyHash, fileName.length > 0 else {
            return
        }
        let amrPathString = AudioFilesManager.amrPathWithName(fileName).path
        let wavPathString = AudioFilesManager.wavPathWithName(fileName).path
        if FileManager.default.fileExists(atPath: wavPathString) {
            self.playSoundWithPath(wavPathString)
        } else {
            if TSVoiceConverter.convertAmrToWav(amrPathString, wavSavePath: wavPathString) {
                self.playSoundWithPath(wavPathString)
            } else {
                if let delegate = self.delegate {
                    delegate.audioPlayFailed()
                }
            }
        }
        
    }
    
    fileprivate func downloadAudio(_ audioModel: ChatAudioModel) {
        let fileName = audioModel.keyHash!
        let filePath = AudioFilesManager.amrPathWithName(fileName)
        let destination: (URL, HTTPURLResponse) -> (URL) = { (temporaryURL, response)  in
            log.info("checkAndDownloadAudio response:\(response)")
            if response.statusCode == 200 {
                if FileManager.default.fileExists(atPath: filePath.path) {
                    try! FileManager.default.removeItem(at: filePath)
                }
                log.info("filePath:\(filePath)")
                return filePath
            } else {
                return temporaryURL
            }
        }
       
        Alamofire.download(audioModel.audioURL!).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }.responseData { response in
            if let error = response.result.error, let delegate = self.delegate {
                log.error("Failed with error: \(error)")
                delegate.audioPlayFailed()
            } else {
                log.info("Downloaded file successfully")
                self.convertAmrToWavAndPlaySound(audioModel)
            }
            
        }
    }
    
}

extension AudioPlayManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        log.info("Finished playing the song")
        UIDevice.current.isProximityMonitoringEnabled = false
        if flag {
            self.delegate?.audioPlayFinished()
        } else {
            self.delegate?.audioPlayFailed()
        }
        self.stopPlayer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.stopPlayer()
        self.delegate?.audioPlayFailed()
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        self.stopPlayer()
        self.delegate?.audioPlayFailed()
    }
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        
    }
}





