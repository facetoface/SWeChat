//
//  AudioFilesManager.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/14.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

private let kAmrRecordFolder = "ChatAudioAmrRecord"
private let kWavRecordFolder = "ChatAudioWavRecord"


class AudioFilesManager: NSObject {

    @discardableResult
    class func amrPathWithName(_ fileName: String) -> URL {
        let filePath = self.armFilesFolder.appendingPathComponent("\(fileName).\(kAudioFileTypeAmr)")
        return filePath
    }
    
    @discardableResult
    class func wavPathWithName(_ fileName: String) -> URL {
        let filePath = self.wavFilesFolder.appendingPathComponent("\(fileName).\(kAudioFileTypeWav)")
        return filePath
    }
    
    @discardableResult
    class func renameFile(_ originPath: URL, destinationPath: URL) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: originPath.path, toPath: destinationPath.path)
            return true
        } catch let error as NSError {
            log.error("error: \(error)")
            return false
        }
    }
    
    @discardableResult
    class fileprivate func createAudioFolder(_ folderName : String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let folder = documentsDirectory.appendingPathComponent(folderName)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folder.absoluteString) {
            do {
                try fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
                return folder
            } catch let error as NSError {
                log.error("error: \(error)")
            }
        }
        return folder
    }
    
    
    fileprivate class var armFilesFolder: URL {
        get { return self.createAudioFolder(kAmrRecordFolder) }
    }
    
    fileprivate class var wavFilesFolder: URL {
        get { return self.createAudioFolder(kWavRecordFolder) }
    }
    
    class func deletAllRecordingFiles() {
        self.deletFilesWithPath(self.armFilesFolder.path)
        self.deletFilesWithPath(self.wavFilesFolder.path)
    }
    
    fileprivate class func deletFilesWithPath(_ path: String) {
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            var recordings = files.filter({ (name: String) -> Bool in
                return name.hasSuffix(kAudioFileTypeWav)
            })
            for i in 0 ..< recordings.count {
                let path = path + "/" + recordings[i]
                log.info("removing \(path)")
                do {
                    try fileManager.removeItem(atPath: path)
                    
                } catch let error as NSError {
                    log.info("could not move \(path)")
                    log.info(error.localizedDescription)
                }
            }
        } catch let error as NSError {
            log.info("could not get contents of directory at \(path)")
            log.info(error.localizedDescription)
        }
    }
}

