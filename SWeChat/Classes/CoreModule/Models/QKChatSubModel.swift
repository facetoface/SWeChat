//
//  QKChatSubModel.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/10.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatAudioModel: NSObject, QKModelProtocol {
    
    var audioId: String?
    var audioURL: String?
    var bitRate: String?
    var channels: String?
    var createTime: String?
    var duration: Float?
    var fileSize: String?
    var formatName: String?
    var keyHash: String?
    var mimeType: String?
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        audioId <- map["audio_id"]
        audioURL <- map["audio_url"]
        bitRate <- map["bit_rate"]
        channels <- map["channels"]
        createTime <- map["ctime"]
        duration <- (map["duration"], TransformerStringToFloat)
        fileSize <- map["file_size"]
        formatName <- map["format_name"]
        keyHash <- map["key_hash"]
        mimeType <- map["mime_type"]
    }
    
}

class ChatImageModel: NSObject, QKModelProtocol {
    var imageHeight: CGFloat?
    var imageWidth: CGFloat?
    var imageId: String?
    var originalURL: String?
    var thumbURL: String?
    var localStoreName: String?
    var localThumbnailImage: UIImage?
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}



