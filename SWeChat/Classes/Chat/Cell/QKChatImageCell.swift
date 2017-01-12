//
//  QKChatImageCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/12.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

let kChatImageMaxWidth: CGFloat = 125
let kChatImageMinWidth: CGFloat = 50
let kChatImageMaxHeight: CGFloat = 150
let kChatImageMinHeight: CGFloat = 50


class QKChatImageCell: QKChatBaseCell {

    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer()
        self.chatImageView.addGestureRecognizer(tap)
        self.chatImageView.isUserInteractionEnabled = true
        tap.rx.event.subscribe { [weak self] _ in
            if let strongSelf = self {
                guard let delegate = strongSelf.delegate else {
                    return
                }
                delegate.cellDidTapedImageView(strongSelf)
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    override func setCellContent(_ model: QKChatModel) {
        super.setCellContent(model)
        if let localThumbnailImage = model.imageModel!.localThumbnailImage {
            self.chatImageView.image = localThumbnailImage
        } else {
            self.chatImageView.qk_setImageWithURLString(model.imageModel!.thumbURL)
        }
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard  let model = self.model else {
            return
        }
        guard  let imageModel = model.imageModel else {
            return
        }
        
        var imageOriginalWidth = kChatImageMinWidth
        var imageOriginalHeight = kChatImageMinWidth
        if (imageModel.imageId != nil) {
            imageOriginalWidth = imageModel.imageWidth!
        }
        if (imageModel.imageHeight != nil) {
            imageOriginalHeight = imageModel.imageHeight!
        }
        
        let originalSize = CGSize.init(width: imageOriginalWidth, height: imageOriginalHeight)
        self.chatImageView.size = QKChatConfig.getThumbImageSize(originalSize)
        
        if model.fromMe {
            self.chatImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - self.chatImageView.width
        } else {
            self.chatImageView.left = kChatBubbleLeft
        }
        
        self.chatImageView.top = self.avatarImageView.top
        
        let stretchInsets = UIEdgeInsetsMake(30, 28, 23, 28)
        let stretchImage = model.fromMe ? TSAsset.SenderImageNodeMask.image : TSAsset.ReceiverImageNodeMask.image
        let bubbleMaskImage = stretchImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        
        let layer = CALayer()
        layer.contents = bubbleMaskImage.cgImage
        layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        layer.frame = CGRect.init(x: 0, y: 0, width: self.chatImageView.width, height: self.chatImageView.height)
        layer.contentsScale = UIScreen.main.scale
        layer.opacity = 1
        self.chatImageView.layer.mask = layer
        self.chatImageView.layer.masksToBounds = true
        
        let stretchConverImage = model.fromMe ? TSAsset.SenderImageNodeBorder.image : TSAsset.ReceiverImageNodeBorder.image
        let bubbleConverImage = stretchConverImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        self.coverImageView.image = bubbleConverImage
        self.coverImageView.frame = CGRect.init(x: self.chatImageView.left - 1, y: self.chatImageView.top, width: self.chatImageView.width + 2, height: self.chatImageView.height + 2)
        
    }
    
    class func layoutHeight(_ model: QKChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        guard let imageModel = model.imageModel else {
            return 0
        }
        var height = kChatAvatarMarginTop + kChatBubblePaddingBottom
        
        let imageOriginalWidth = imageModel.imageWidth!
        let imageOriginalHeight = imageModel.imageHeight!
        
        if imageOriginalHeight >= imageOriginalWidth {
            height += kChatImageMaxHeight
        } else {
            let scaleHeight = imageOriginalHeight * kChatImageMaxWidth / imageOriginalWidth
            height += (scaleHeight > kChatImageMinHeight) ? scaleHeight : kChatImageMinHeight
        }
        height += 12
        model.cellHeight = height
        return model.cellHeight
    }
    
    func CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect {
        return CGRect(
            x: image.capInsets.left / image.size.width,
            y: image.capInsets.top / image.size.height,
            width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func _maskImage(_ image: UIImage, maskImage: UIImage) -> UIImage {
        let maskRef: CGImage = maskImage.cgImage!
        let mask: CGImage = CGImage.init(maskWidth: maskRef.width, height: maskRef.height, bitsPerComponent: maskRef.bitsPerComponent, bitsPerPixel: maskRef.bitsPerPixel, bytesPerRow: maskRef.bytesPerRow, provider: maskRef.dataProvider!, decode: nil, shouldInterpolate: false)!
        let maskedIamgeRef: CGImage = (image.cgImage)!.masking(mask)!
        let maskedImage: UIImage = UIImage.init(cgImage: maskedIamgeRef)
        return maskedImage
    }
    
}
