//
//  Extension+json.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/6/6.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation


/// 数据转换为字符串
public protocol JSerializationJsonString {
    func toString() -> String
}

/**
 字典|数组 转换字符串
 - returns: 返回字符串
 */
public extension JSerializationJsonString{
  
    func toString()->String{
        var strJson: String = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            strJson=NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            
        }
        return strJson
    }

}

// MARK: - 字典遵循 转换字符串协议
extension Dictionary: JSerializationJsonString{}


// MARK: - 数组遵循 转换为字符串协议
extension Array: JSerializationJsonString{}


// MARK: - 字符串转换为 字典|数组
public extension String{
    
    func toArray() -> Array<Any>? {
        return to() as? Array
    }
    
    func toDictionary() -> Dictionary<String, Any>? {
        return to() as? Dictionary
    }
    
    fileprivate func to()->Any?{
        let data = self.data(using: .utf8)
        /** *
         NSJSONReadingMutableContainers 解析为数组或字典
         NSJSONReadingMutableLeaves 解析为可变字符
         NSJSONReadingAllowFragments 解析为除上面两个以外的格式
         */
        let obj = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        return obj
    }
}
