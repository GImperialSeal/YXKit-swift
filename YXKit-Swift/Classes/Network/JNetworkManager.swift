//
//  NetworkManager.swift
//  HLShare
//
//  Created by HLApple on 2017/12/22.
//  Copyright © 2017年 HLApple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
typealias failureBlock = (WeShareError)->Void
typealias successBlock<R> = (_ res: R)->Void


class NetworkManager {
    
    static let share = NetworkManager()
        
    static func POST<R: JResult>(_ querier: JQuerier<R>, success: @escaping successBlock<R>, failure: @escaping failureBlock){
        querier.success = success
        querier.failure = failure
        NetworkManager.share.POST(querier)
    }
    
    private var manager: SessionManager = {
        /// set up URLSessiong configure
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        configuration.timeoutIntervalForRequest = 30
        
        let sm = Alamofire.SessionManager(configuration: configuration)
        
        // Ignore SSL Challenge
        sm.delegate.sessionDidReceiveChallenge = { session, challenge in
            
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                
                disposition = URLSession.AuthChallengeDisposition.useCredential
                
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                
            } else {
                
                if challenge.previousFailureCount > 0 {
                    
                    disposition = .cancelAuthenticationChallenge
                    
                } else {
                    
                    credential = sm.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        
                        disposition = .useCredential
                        
                    }
                }
            }
            return (disposition, credential)
        }
        return sm
    }()
    
    func POST<R: JResult>(_ querier: JQuerier<R>){
        print("url: \(JConfig.BASE_URL + querier.url)")
        print("params",querier.params)
        manager.request(JConfig.BASE_URL + querier.url,
                          method: .post,
                          parameters: querier.params,
                          headers: querier.headers)
            .validate(contentType: JConfig.contentType)
//            .validate(statusCode: 0 ..< 400)
            .responseJSON{ [weak self] (response) in
                print("json: \(JSON(response.result.value ?? "josn 为空"))")
                self?.handle(response, querier)
        }
    }
    
    func handle<R: JResult>(_ response: DataResponse<Any>,_ querier: JQuerier<R>) {
        switch response.result.isSuccess {
        case true:
            if let data = response.data {
                if let model = R.deserialize(from: String(data: data, encoding: .utf8)){
                    if model.error == 0{
                        /// 如果token变化 就把token 及时更新
                        if let token = model.token{JConfig.token = token}
                        querier.success?(model)
                    }else{
                        let error = WeShareError.ResponseFail(code: model.error, msg: model.desc)
                        querier.failure?(error)
                    }
                }else{
                    querier.failure?(WeShareError.DeserializeFail)
                }
            }else{
                querier.failure?(WeShareError.DataNull)
            }
        case false:
            querier.failure?(WeShareError.NetworkFail(response.error))

        }
       
    }
    
    
    func upload<R: JResult>(_ querier: JUploadQuerier<R>) {
        
        manager.upload(multipartFormData: { (multiData) in
            
            for file in querier.files{
                if file.type == .data{
                    multiData.append(file.data ,withName: file.name, fileName: file.fileName, mimeType: "image/jpeg")
                }else{
                    multiData.append(URL(string: file.path)!, withName: file.name, fileName: file.fileName, mimeType: "file.mimeType")
                }
            }
          
            // 便利参数
            for (key,value) in (querier.params){
                let dataString = JSON(value).string
                multiData.append((dataString?.data(using: .utf8))!, withName: key)
            }
        }, to: JConfig.BASE_URL + querier.url,headers:querier.headers) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.handle(response, querier)
                }
            case .failure(let encodingError):
            querier.failure?(WeShareError.EncodingError(encodingError))
            }
            
        }
        
    }
    
    
    
    
    
    func download<R>(_ querier: JUploadQuerier<R>) {
//        var url: URL!
//        
//        
//        var destPath: URL
//        
//        if destinationPath.count == 0 {
//            
//            let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            
//            destPath = directoryURLs[0].appendingPathComponent("/Music/")
//            
//        } else {
//            
//            destPath = URL(string: destinationPath)!
//            
//        }
//        let destination: Alamofire.DownloadRequest.DownloadFileDestination = { temporaryURL, response in
//            
//            return (destPath.appendingPathComponent("\(url.lastPathComponent.urlDecoded())"), [.createIntermediateDirectories])
//        }
//        
//        return sessionManager.download(URLRequest(url: url), to: destination).response(completionHandler: { response in
//            
//        })
    }
    
    
    
    
    
    
}







