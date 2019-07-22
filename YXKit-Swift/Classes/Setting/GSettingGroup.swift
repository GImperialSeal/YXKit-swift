//
//  GSettingGroup.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/24.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit

class GSettingGroup {
    
    var header: String?
    var footer: String?
    var heightForFooter: CGFloat = 10
    var heightForHeader: CGFloat = 10
    let items: [GSettingItem]!
    
    init(items: [GSettingItem]) {
        self.items = items
    }

}
