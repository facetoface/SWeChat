//
//  QKChatTextParser.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/13.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import YYText

public let kChatTextKeyPhone = "phone"
public let kChatTextKeyURL = "URL"

class QKChatTextParser: NSObject {
    class func parseText(_ text: String, font: UIFont) -> NSMutableAttributedString? {
        if text.characters.count == 0 {
            return nil
        }
        let attributedText: NSMutableAttributedString = NSMutableAttributedString.init(string: text)
        attributedText.yy_font = font
        attributedText.yy_color = UIColor.black
        return attributedText
    }
    
        fileprivate class func enumeratePhoneParser(_ attributedText: NSMutableAttributedString) {
            let phonesResults = QKChatTextParseHelper.regexPhoneNumber.matches(in: attributedText.string, options: [.reportProgress], range: attributedText.yy_rangeOfAll())
            for phone: NSTextCheckingResult in phonesResults {
                if phone.range.location == NSNotFound && phone.range.length <= 1 {
                    continue
                }
                let highlighBorder = QKChatTextParseHelper.highlightBorder
                if (attributedText.yy_attribute(YYTextHighlightAttributeName, at: UInt(phone.range.location)) == nil) {
                    attributedText.yy_setColor(UIColor.init(ts_hexString: "#1F79FD"), range: phone.range)
                    let highlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlighBorder)
                    
                    let stringRange = attributedText.string.range(from: phone.range)!
                    highlight.userInfo = [kChatTextKeyPhone : attributedText.string.substring(with: stringRange)]
                    attributedText.yy_setTextHighlight(highlight, range: phone.range)
                    
                }
            }
        }
    
    fileprivate class func enumerateURLParser(_ attributedText: NSMutableAttributedString) {
        let URLsResults = QKChatTextParseHelper.regexURLs.matches(
            in: attributedText.string,
            options: [.reportProgress],
            range: attributedText.yy_rangeOfAll()
        )
        for URL: NSTextCheckingResult in URLsResults {
            if URL.range.location == NSNotFound && URL.range.length <= 1 {
                continue
            }
            let highlightBorder = QKChatTextParseHelper.highlightBorder
            if (attributedText.yy_attribute(YYTextHighlightAttributeName, at: UInt(URL.range.location)) == nil) {
                let highlight = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                let stringRange = attributedText.string.range(from: URL.range)!
                highlight.userInfo = [kChatTextKeyURL : attributedText.string.substring(with: stringRange)]
                attributedText.yy_setTextHighlight(highlight, range: URL.range)
            }
        }
    }
    
    fileprivate class func enumerateEmotionParser(_ attributedText: NSMutableAttributedString, fontSize: CGFloat) {
        let emotionResults = QKChatTextParseHelper.regexEmotions.matches(in: attributedText.string, options: [.reportProgress], range: attributedText.yy_rangeOfAll())
        var emoClipLength: Int = 0
        for emotion: NSTextCheckingResult in emotionResults {
            if emotion.range.location == NSNotFound && emotion.range.length <= 1 {
                continue
            }
            var range: NSRange = emotion.range
            range.location -= emoClipLength
            if (attributedText.yy_attribute(YYTextHighlightAttributeName, at: UInt(range.location)) != nil) {
                continue
            }
            if (attributedText.yy_attribute(YYTextAttachmentAttributeName, at: UInt(range.location)) != nil) {
                continue
            }
            
            let imageName = attributedText.string.substring(with: attributedText.string.range(from: range)!)
            guard let theImageName = QKEmojiDictionary[imageName] else {
                continue
            }
            
            let imageString = "\(QKConfig.ExpressionBundleName)/\(theImageName)"
            let emojiText = NSMutableAttributedString.yy_attachmentString(withEmojiImage: UIImage.init(named: imageString)!, fontSize: fontSize + 1)
            attributedText.replaceCharacters(in: range, with: emojiText!)
            emoClipLength += range.length - 1
        }
    }
}

class QKChatTextParseHelper {
   
    class var highlightBorder: YYTextBorder {
        get {
            let highlightBorder = YYTextBorder()
            highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
            highlightBorder.fillColor = UIColor.init(ts_hexString: "#D4D1D1")
            return highlightBorder
        }
    }
    
    class var regexEmotions: NSRegularExpression {
        get {
            let regularExpression = try! NSRegularExpression.init(pattern: "\\[[^\\[\\]]+?\\]", options: [.caseInsensitive])
            return regularExpression
        }
    }
    
    class var regexURLs: NSRegularExpression {
        get {
            let regex: String = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|^[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\\(\\)/,:;@&=\\?~#%]*)*"
            let regularExpression = try! NSRegularExpression.init(pattern: regex, options: [.caseInsensitive])
            return regularExpression
        }
    }
    
    class var regexPhoneNumber: NSRegularExpression {
        get {
            let regex =  "([\\d]{7,25}(?!\\d))|((\\d{3,4})-(\\d{7,8}))|((\\d{3,4})-(\\d{7,8})-(\\d{1,4}))"
            let regularExpression = try! NSRegularExpression.init(pattern: regex, options: [.caseInsensitive])
            return regularExpression
        }
    }
    
}

private extension String {
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = range.lowerBound.samePosition(in: utf16view)
        let to = range.upperBound.samePosition(in: utf16view)
        return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else {
                return nil
        }
        
        return from ..< to
    }
    
    
}
