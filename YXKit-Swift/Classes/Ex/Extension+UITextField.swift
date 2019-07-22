//
//  TextFeildTool.swift
//  HLShare
//
//  Created by HLApple on 2018/1/12.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import UIKit

//MARK: 限制输入框长度
//private var limitLengthKey: UInt8 = 0
//private var complecionEditingKey: UInt8 = 0
private var key: Void?

public extension UITextField{
    
    typealias complecionEditingBlock = (_ text: String)->Void
    
    var limitLength: Int?{
        get{
            return (objc_getAssociatedObject(self, &key) as? Int)!
        }
        set(newValue){
            self.addTarget(self, action: #selector(gf_TextFieldDidChange(textField:)), for: .editingChanged)
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var complecionEditing: complecionEditingBlock?{
        get{
            return objc_getAssociatedObject(self, &key) as? UITextField.complecionEditingBlock
        }
        set(newValue){
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
     @objc private func gf_TextFieldDidChange(textField: UITextField) {
        if complecionEditing != nil {
            complecionEditing!(textField.text!)
        }
        let maxLength = textField.limitLength
        
        if markedTextRange?.start == nil {
            let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
            let data = text?.data(using: String.Encoding(rawValue: enc))
            let dataLength = (data?.count)! as Int
            print(dataLength)
            if dataLength > maxLength! {
                let subData = data?.subdata(in: 0 ..< maxLength!)
                var limitStr = String(data: subData!, encoding: String.Encoding(rawValue: enc))
                if limitStr == nil {
                    limitStr = String(data: (data?.subdata(in: 0 ..< maxLength!-1))!, encoding: String.Encoding(rawValue: enc))
                }
                setValue(limitStr, forKey: "text")
            }
        }
    }
}
