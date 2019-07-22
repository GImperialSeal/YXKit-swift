//
//  JResult.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/5/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import HandyJSON


class JResult: HandyJSON {
    var error: Int = -10
    var desc: String?
    var token: String?
    required init() {}
    func didFinishMapping() { }
}

class JListResult<E> : JResult {
    var entities: [E]? {
        get {return nil}
        set {}
    }
    required init(){}
    override func didFinishMapping() { }
}
