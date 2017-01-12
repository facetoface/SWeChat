//
//  QKChatConfig.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/12.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import UIKit

open class QKChatConfig{

    class func getThumbImageSize(_ originalSize: CGSize) -> CGSize {
        let imageRealHeight = originalSize.height
        let imageRealWidth = originalSize.width
      
        var resizeThumbWidth: CGFloat
        var resizeThumbHeight: CGFloat
        if imageRealHeight >= imageRealWidth {
            let scaleWidth = imageRealWidth * kChatImageMaxHeight / imageRealHeight
            resizeThumbWidth = (scaleWidth > kChatImageMinWidth) ? scaleWidth : kChatImageMinWidth
            resizeThumbHeight = kChatImageMaxHeight
        } else {
            let scaleHeight = imageRealHeight * kChatImageMaxWidth / imageRealWidth
            resizeThumbHeight = (scaleHeight > kChatImageMinHeight) ? scaleHeight : kChatImageMinHeight
            resizeThumbWidth = kChatImageMaxWidth
        }
        
        return CGSize.init(width: resizeThumbWidth, height: resizeThumbHeight)
    }
}
