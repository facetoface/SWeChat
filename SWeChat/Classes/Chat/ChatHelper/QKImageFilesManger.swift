//
//  QKImageFilesManger.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/10.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import Kingfisher

class QKImageFilesManger {
    let imageCacheFolder = KingfisherManager.shared.cache
    
    @discardableResult
    class func cachePathForKey(_ key: String) -> String? {
        let fileName = key.ts_MD5String
        return (KingfisherManager.shared.cache.diskCachePath as NSString).appending(fileName)
    }
    
    class func storeImage(_ image: UIImage, key: String, completionHandler:(() -> ())?) {
        KingfisherManager.shared.cache.removeImage(forKey: key)
        KingfisherManager.shared.cache.store(image, forKey: key, toDisk: true, completionHandler: completionHandler)
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
    
}
