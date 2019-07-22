//
//  StringTool.swift
//  HLShare
//
//  Created by HLApple on 2018/1/4.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import UIKit

extension String {
    
    /// 计算字符串第一次出现的位置
    ///
    /// - Parameter sub: 字符
    /// - Returns: 位置
    func positionOf(sub:String)->Int? {
        if let range = range(of:sub),!range.isEmpty {
            return distance(from:startIndex, to:range.lowerBound)
        }
        return nil
    }
    
    /// 判断字符串为空
    func isEmpty(_ str: String?) ->Bool{
        if let s = str,s.count > 0 {return false}
        return true
    }
    
    //获取部分字符串，如果不在范围内，返回nil.如果end大于字符串长度，那么截取到最后
    subscript (start: Int, end: Int) -> String? {
        if start > count || start < 0 || start > end {
            return nil
        }
        let begin = index(startIndex, offsetBy: start)
        var terminal: Index
        if end >= count {
            terminal = index(startIndex, offsetBy: count)
        } else {
            terminal = index(startIndex, offsetBy: end + 1)
        }
        return String(self[begin ..< terminal])
    }
    
    
    /// 给字符串添加 空格 逗号 等符号
    /// exp:4444 5555 6666 7777   1,000,000,000
    /// - Parameters:
    ///   - per: 每隔几个字符添加一个 符号
    ///   - charts: 符号 默认添加一个空格
    ///   - from: 添加的顺序, 从字符串的开头或者结尾添加 默认startIndex添加
    @discardableResult
    mutating func insertCharts(_ per: Int = 4,_ charts: String = " ",_ fromStartIndex: Bool = true) -> String {
        let spaceCount = Int(count/per)
        if count > per {
            for i in 1 ... spaceCount {
                let tempIndex = fromStartIndex ? index(startIndex, offsetBy: per*i + (i-1)) : index(endIndex, offsetBy: -per*i - (i-1))
                insert(contentsOf: charts, at: tempIndex)
            }
        }
       
        return self
    }
   
    
}
