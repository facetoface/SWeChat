//
//  QKChatEmotionCell.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/9.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKChatEmotionCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionImageView: UIImageView!
    internal var isDelete: Bool = false
    var emotionModel: EmotionModel? = nil
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.emotionImageView.image = nil
        self.emotionModel = nil
    }
    
    func setCellContent(_ model: EmotionModel? = nil)  {
        guard let model = model else {
            self.emotionImageView.image = nil
            return
        }
        self.emotionModel = model
        self.isDelete = false
        if let path = QKConfig.ExpressionBundle!.path(forResource: model.imageString, ofType: "png") {
            self.emotionImageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    func setDeleteCellContent() {
        self.emotionModel = nil
        self.isDelete = true
        self.emotionImageView.image = TSAsset.Emotion_delete.image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

struct EmotionModel {
    var imageString: String!
    var text: String!
    init(fromDictionary dictionary: NSDictionary) {
        let imageText = dictionary["image"] as! String
        imageString = "\(imageText)@2x"
        text = dictionary["text"] as? String
    }
}
