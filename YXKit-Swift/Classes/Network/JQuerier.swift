//
//  JQuerier.swift
//  HLShare
//
//  Created by HLApple on 2018/1/19.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import Foundation
import UIKit
class JQuerier<R: JResult>{
    
    var url: String = ""
    
    var needToken: Bool = true{
        didSet{
            if needToken {
                params.updateValue(JConfig.token, forKey: "token")
            }
        }
    }
    
    var params: [String: Any] =  ["silent": "true"]
    
    var headers: [String: String]? = nil
    
    var success: successBlock<R>?
    
    var failure: failureBlock?
    
    var pager: JPager?
    
    // 默认为空字符串
    init(_ url: String = "") {self.url = url}
}



class JUploadQuerier<R: JResult>: JQuerier<R> {
    
    var files: [JFile] { return tempFiles }
    
    fileprivate var tempFiles: [JFile] = []
    
    /// 图片压缩比例 默认.5
    var compressionQuality: CGFloat = 0.5

    /// 添加图片
    func handleImage(image: UIImage){
        if let data = UIImageJPEGRepresentation(image, compressionQuality){
            tempFiles.append(JFile(data))
        }
    }
    
    override init(_ url: String) {
        super.init(url)
        headers = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]
    }
}

enum JFileType{
    case data
    case path
}
struct JFile {
    /// 文件格式
    var format = ".jpg"
    
    var data: Data
    
    var name: String = "pic1"
    
    var type: JFileType = .data
    
    var mineType: String = "image/jpeg"
    
    var path: String = ""
    
    /// 文件名
    var fileName: String{
        get{
            let format  = DateFormatter(); format.dateFormat = "yyyyMMddHHmmss"
            let now = Date(timeIntervalSinceNow: 0)
            let dataString = format.string(from: now)
            return dataString + self.format
        }
    }
    
    init(_ data: Data) {
        self.data = data
    }
    
}

