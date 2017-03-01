//
//  QKUploadModel.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/28.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import ObjectMapper

class QKUploadImageModel: QKModelProtocol {
    var originalURL : String?
    var originalHeight : CGFloat?
    var originalWidth : CGFloat?
    var thumbURL : String?
    var thumbHeight : CGFloat?
    var thumbWidth : CGFloat?
    var imageId : Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        originalURL <- map["original_URL"]
        originalHeight <- map["original_height"]
        originalWidth <- map["original_width"]
        imageId <- map["image_Id"]
        thumbURL <- map["thumb_URL"]
        thumbHeight <- map["thumb_heigt"]
        thumbWidth <- map["thumb_width"]
    }
    
    
}

class  QKUploadAudioModel: QKModelProtocol {
    var audioId : String?
    var duration : Int?
    var audioURL : String?
    var fileSize : Int?
    var keyHash : String?
    var recordTime : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        audioId <- map["audio_id"]
        audioURL <- map["auidio_url"]
        duration <- map["duration"]
        keyHash <- map["key_hash"]
        fileSize <- map["file_size"]
        recordTime <- map["recordTime"]
    }
    
}
