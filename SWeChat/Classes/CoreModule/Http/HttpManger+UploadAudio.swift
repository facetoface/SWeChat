//
//  HttpManger+UploadAudio.swift
//  SWeChat
//
//  Created by ChiCo on 17/3/1.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import Alamofire

extension HttpManager {
    class func uploadAudio(_ audioData: Data,
                           recordTime: String,
                           success:@escaping(_ audioModel: QKUploadAudioModel) -> Void,
                           failure:@escaping(Void) -> Void) {
        
        let parameters = [
            "access_token": UserInstance.accessToken,
            "record_time": recordTime]
        let uploadAudioURLString = ""
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioData, withName: "file", mimeType: "audio/AMR")
            for (key, value) in parameters {
                multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: uploadAudioURLString) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseData(completionHandler: { response in
                    log.info("response: \(response)")
                    
                    switch response.result {
                    case .success(let data):
                        let model: QKUploadAudioModel = QKMapper<QKUploadAudioModel>().map(JSONObject: data)!
                        success(model)
                    case .failure(_):
                        failure()
                    }
                    
                })
                
            case .failure(let encodingError):
                debugPrint(encodingError)
                
            }
        }
    }
    
}
