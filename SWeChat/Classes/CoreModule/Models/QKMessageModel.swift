//
//  MessageModel.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/5.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import ObjectMapper

class MessageModel: NSObject,QKModelProtocol {
    var middleImageURL : String?
    var unreadNumber : Int?
    var nickname: String?
    var messageFromType: MessageFromeType = MessageFromeType.Personal
    var messageContentType: MessageContentType = MessageContentType.Text
    var chatId: String?
    var latestMessage: String?
    var dateString: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        middleImageURL <- map["avatar_url"]
        unreadNumber <- map["message_unread_num"]
        nickname <- map["nickname"]
        messageFromType <- (map["meesage_from_type"],EnumTransform<MessageFromeType>())
        chatId <- map["userid"]
        latestMessage  <- map["last_message.message"]
        messageContentType <- (map["last_message.message_content_type"],EnumTransform<MessageContentType>())
        dateString <- (map["last_message.timestamp"],TransformerTimestampToTimeAgo)
    }
    
    
}
