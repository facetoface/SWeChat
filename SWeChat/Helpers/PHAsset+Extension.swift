//
//  PHAsset+Extension.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/28.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    func getUIImage() -> UIImage? {
        let manger = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        var image: UIImage?
        manger.requestImage(for: self,
                            targetSize: CGSize.init(width: CGFloat(self.pixelWidth), height: CGFloat(self.pixelHeight)), contentMode: .aspectFit, options: options) { (result, info) in
                                if let theResult = result {
                                    image = theResult
                                } else {
                                    image = nil
                                }
                                
        }
        return image
    }
}
