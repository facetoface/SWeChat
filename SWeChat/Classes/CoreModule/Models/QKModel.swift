//
//  QKModel.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/4.
//  Copyright © 2017年 ChiCo. All rights reserved.
//
import Foundation
import ObjectMapper

typealias QKModelProtocol = ObjectMapper.Mappable;
typealias QKMapper = ObjectMapper.Mapper;

enum GenderType: Int {
    case female = 0,
    male
}

enum MessageContentType: String {
    case Text = "0"
    case Image = "1"
    case Voice = "2"
    case System = "3"
    case File = "4"
    case Time = "110"
}

enum MessageFromeType: String {
    case System = "0"
    case Personal = "1"
    case Group = "2"
    case PublicServer = "3"
    case PublicSubscribe = "4"
    var placeHolderImage: UIImage {
        switch (self) {
        case .Personal:
            return TSAsset.Icon_avatar.image
        case .System, .Group, .PublicServer, .PublicSubscribe:
            return TSAsset.Icon_avatar.image
        }
    }
}

enum MessageSendSuccessType: Int {
    case success = 0
    case failed
    case sending
}


