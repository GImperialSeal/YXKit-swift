//
//  GSettingItem.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/24.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit

enum GSettingItemType {
    case Default
    case Value1
    case TextField
    case Signout
    case Custom
}
class GSettingItem {
    typealias operationBlock = (GSettingItem,IndexPath)->()
    typealias finishedEditedBlock = (String)->()
    typealias clickedAccessoryViewBlock = (GSettingItem,IndexPath,UIButton)->()

    var icon: String?
    var rowHeight: CGFloat = 44
    var title: String?
    var subtitle: String?
    var placeholder: String?
    var keyType: UIKeyboardType?
    var titleColor: UIColor?
    var subTitleColor: UIColor?
    var signoutColor: UIColor?
    var titleFont: UIFont?
    var subtitleFont: UIFont?
    let type: GSettingItemType
    var operation: operationBlock?
    var clickedAccessoryView: clickedAccessoryViewBlock?
    var finishedEdited: finishedEditedBlock?
    var limitEditLength = 100
    var showDisclosureIndicator:Bool = true
    
    init(type: GSettingItemType = .Default) {
        titleFont = KMAIN_FONT(size: 15)
        subtitleFont = KMAIN_FONT(size: 15)
        titleColor = UIColor.black
        subTitleColor = UIColor.gray
        signoutColor = UIColor.red
        self.type = type
    }
    
    convenience init(value1 title: String,subtitle: String,showDisclosureIndicator: Bool = true,op:operationBlock? = nil) {
        self.init(type: .Value1)
        self.title = title
        self.subtitle = subtitle
        self.showDisclosureIndicator = showDisclosureIndicator
        self.operation = op
    }
    
    convenience init(textField title: String,
                     placeholder: String,
                     showAccessoryView: Bool = false,
                     clickedAccessoryView: clickedAccessoryViewBlock? = nil,
                     finishedEdited:@escaping finishedEditedBlock) {
        self.init(type: .TextField)
        self.title = title
        self.placeholder = placeholder
        self.finishedEdited = finishedEdited
        self.showDisclosureIndicator = showAccessoryView
        self.clickedAccessoryView = clickedAccessoryView
    }
    
    convenience init(signout title: String,op:@escaping operationBlock) {
        self.init(type: .Signout)
        self.title = title
        self.operation = op
    }
    
    convenience init(custom title: String,subtitle: String,op: operationBlock? = nil) {
        self.init(type: .Custom)
        self.title = title
        self.subtitle = subtitle
        self.operation = op
        
    }
    
    convenience init(default icon:String = "", title: String,showDisclosureIndicator: Bool = true,op: operationBlock? = nil) {
        self.init(type: .Default)
        self.title = title
        self.icon = icon
        self.operation = op
        self.showDisclosureIndicator = showDisclosureIndicator
    }
 
}
