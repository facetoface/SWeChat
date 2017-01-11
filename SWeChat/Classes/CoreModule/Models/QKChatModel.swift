//
//  QKChatModel.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/10.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import ObjectMapper
import YYText

class QKChatModel: NSObject, QKModelProtocol {
    
    var audioModel: ChatAudioModel?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
}
