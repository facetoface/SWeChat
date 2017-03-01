//
//  HttpManager+UploadImage.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/28.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import Alamofire

extension HttpManager {
    
    class func uploadSingleImage(_ image: UIImage,
                                 success: @escaping(_ imageModel: QKUploadImageModel) -> Void,
                                 failure: @escaping(Void) -> Void){
        let parameters = [
        "access_token": UserInstance.accessToken
        ]
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let uploadImageURLString = ""
        Alamofire.upload(multipartFormData: { multipartFormData in
            if imageData != nil {
                multipartFormData.append(imageData!, withName: "attach", fileName: "file", mimeType: "image/jpeg")
            }
            for (key , value) in parameters {
                multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: uploadImageURLString,    encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        /*
                         根据 JSON 返回格式，做好 UploadImageModel 的 key->value 映射, 这里只是个例子
                         */
                        let model: QKUploadImageModel = QKMapper<QKUploadImageModel>().map(JSONObject:data)!
                        success(model)
                    case .failure( _):
                        failure()
                    }
                }
            case .failure(let encodingError):
                debugPrint(encodingError)
            }
        })
    }
    
}
