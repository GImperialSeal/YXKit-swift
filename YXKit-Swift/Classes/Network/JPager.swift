//
//  JPager.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/5/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class JPager {
    /** 页码 */
    var page : Int = 0
    /** 每页长度。0将被忽略。 */
    var pageSize : Int = 0
    /** 填充量，表示待获取记录之前实际被删除的元素数目 */
    var pad : Int = 0
    
    init() {}
    init(_ page : Int) {
        self.page = page;
    }
    init(_ page : Int , _ pageSize : Int) {
        self.page = page;
        self.pageSize = pageSize;
    }
    /**
     * 增加一页
     * @return
     */
    @discardableResult
    func increase() -> Int {
        page += 1
        return page
    }
    /**
     * 填充到参数集中
     * @param params 参数集
     */
    func fill(_ params : inout [String : Any]) {
        params["pager.page"] = page
        if (pageSize > 0) { params["pager.pageSize"] = pageSize }
        if (pad != 0) { params["pager.pad"] = pad }
    }
    
}
