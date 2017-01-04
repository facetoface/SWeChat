//
//  QKImageView+WebChat.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/4.
//  Copyright © 2017年 ChiCo. All rights reserved.
//
import Foundation
import Kingfisher

public extension UIImageView {
    
    func qk_setImageWithURLString(_ URLString: String?, placeholderImage placeholder: UIImage? = nil)  {
        guard let URLString = URLString, let URL = URL(string: URLString) else {
            print("URL wrong")
            return
        }
        self.kf.setImage(with: URL)
    }
    
    func qk_setCircularImageWithURLString(_ URLString: String,placeholderImage placeholder: UIImage? = nil) {
        self.qk_setRoundImageWithURLString(URLString,
                                           placeholderImage: placeholder,
                                           cornerRadiusRatio: self.ts_width / 2 )
        
    }
    
    func qk_setRoundImageWithURLString(_ URLString: String?,
                                       placeholderImage placeholder: UIImage? = nil,
                                       cornerRadiusRatio: CGFloat? = nil,
                                       progressBlock: ImageDownloaderProgressBlock? = nil)
    {
        guard let URLString = URLString, let URL = URL(string: URLString) else {
            print("URL wrong")
            return
        }
        
        let memoryImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: URLString)
        let diskImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: URLString)
        guard let image = memoryImage ?? diskImage else {
            let optionInfo: KingfisherOptionsInfo = [
                .forceRefresh,
                ]
            KingfisherManager.shared.downloader.downloadImage(with: URL, options: optionInfo, progressBlock: progressBlock) { (image, error, imageURL, originalData) -> () in
                if let image = image, let originalData = originalData {
                    DispatchQueue.global(qos: .default).async {
                        let roundedImage = image.ts_roundWithCornerRadius(image.size.width * (cornerRadiusRatio ?? 0.5))
                        KingfisherManager.shared.cache.store(roundedImage, original: originalData, forKey: URLString, toDisk: true, completionHandler: {
                            self.qk_setImageWithURLString(URLString)
                        })
                    }
                }
            }
            return
        }
        self.image = image

        
    }
    
}
