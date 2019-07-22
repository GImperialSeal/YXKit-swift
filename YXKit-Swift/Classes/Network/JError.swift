//
//  JError.swift
//  HLShare
//
//  Created by HLApple on 2018/1/19.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import Foundation

enum WeShareError: Swift.Error{
    case DataNull
    case DeserializeFail
    case NetworkFail(Error?)
    case ResponseFail(code: Int,msg: String?)
    case EncodingError(Error)
}
extension WeShareError{
    var desc: String{
        switch self {
        case .DataNull:
            return "关键数据为空"
        case .DeserializeFail:
            return "数据解析失败!"
        case .NetworkFail(let error):
            //            return "网络连接失败, 请检查网络设置."
            return "error: \(String(describing: error))"
        case .ResponseFail( _,let message):
            return message ?? "服务器没有返回描述"
        case .EncodingError(let encodingError):
            return "编码错误: \(encodingError)"
        }
    }
}
