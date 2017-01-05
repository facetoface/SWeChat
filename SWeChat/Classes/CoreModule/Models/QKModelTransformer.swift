//
//  QKModelTransformer.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/5.
//  Copyright © 2017年 ChiCo. All rights reserved.
//
import CoreLocation
import Foundation
import ObjectMapper

let TransformerTimestampToTimeAgo = TransformOf<String, NSNumber>(fromJSON: {
    (value: AnyObject?) -> String? in
    guard let value = value else {
        return ""
    }
    
    let seconds = Double(value as! NSNumber)/1000
    let timeInterval: TimeInterval = TimeInterval(seconds)
    let date = Date(timeIntervalSince1970: timeInterval)
    let string = Date.messageAgoSinceDate(date)
    return string
    
}, toJSON:{ (value: String?) -> NSNumber? in
    return nil
})

let TransformerStringToFloat = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
    guard let value = value else {
        return 0
    }
    let intValue: Float? = Float(value)
    return intValue
    
}, toJSON: { (value: Float?) -> String? in
    if let value = value {
        return String(value)
    }
    return nil
})


let TransformerStringToInt = TransformOf<Int, String> (fromJSON: { (value: String?) -> Int? in
    guard let value = value else {
        return 0
    }
    let intValue: Int? = Int(value)
    return intValue
    
}, toJSON: { (value: Int?) -> String? in
    
    if let value = value {
        return String(value)
    }
    return nil
})


let TransformerStringToCGFloat = TransformOf <CGFloat, String> (fromJSON: { (value: String?) -> CGFloat? in
    guard let value = value else {
        return nil
    }
    let floatValue: CGFloat? = CGFloat(Int(value)!)
    return floatValue
    
}, toJSON: { (value: CGFloat?) -> String? in
    
    if let value = value {
        return String(describing: value)
    }
    return nil
})

let TransformerArrayToLocation = TransformOf<CLLocation, [Double]>(fromJSON: { (value: [Double]?) -> CLLocation? in
    if let coordList = value, coordList.count == 2 {
        return CLLocation(latitude: coordList[1], longitude: coordList[0])
    }
    return nil
}, toJSON: { (value: CLLocation?) -> [Double]? in
    if let location = value {
        return [Double(location.coordinate.longitude), Double(location.coordinate.latitude)]
    }
    return nil
})


