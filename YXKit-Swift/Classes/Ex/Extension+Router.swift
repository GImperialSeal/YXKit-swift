//
//  Extension+Router.swift
//  Alamofire
//
//  Created by 顾玉玺 on 2018/6/6.
//

import UIKit

public typealias EventBlock = (Any?)->Void

private var key: Void?

private typealias StragetgyDictionary = [String: (EventBlock,Bool)]


public extension UIResponder{
    
    func routerEvent(eventName: String,_ info: Any? = nil) {
        if let s = stragetgy, let a = s[eventName]{
            
            // 回调block
            a.0(info)
            
            // 事件不向下传递, 直接return
            if !a.1 {return}
        }
        next?.routerEvent(eventName: eventName, info)
    }
    
    
    func registerEvent(eventName: String, block: @escaping EventBlock, next: Bool) {
        guard let _ = stragetgy else{
            stragetgy = StragetgyDictionary()
            stragetgy!.updateValue((block,next), forKey: eventName)
            return
        }
        stragetgy!.updateValue((block,next), forKey: eventName)
    }
    
    
    // 存放回调事件
    private var stragetgy: StragetgyDictionary?{
        get{
            return objc_getAssociatedObject(self, &key) as? StragetgyDictionary
        }
        set(newValue){
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
