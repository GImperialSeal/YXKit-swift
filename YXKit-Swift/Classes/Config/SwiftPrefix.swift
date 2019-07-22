//
//  CashSoSoPrefix.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/7/25.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import Foundation
import UIKit

//import Hue // 颜色库

// 屏幕宽、高、状态栏高度
let KW = UIScreen.main.bounds.width
let KH = UIScreen.main.bounds.height
let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
let KSCALE_HEIGHT = KH/568
let KSCALE_WIDTH  = KW/320
let KSPACE: CGFloat = UIDevice.current.model.contains("plus") ? 20 : 15

func ADAPTOR_HEIGHT(imageName:String,space:CGFloat = 0)->CGFloat{
    let height = UIImage(named: imageName)?.size.height
    let scale = (KW - space*2)/(320-space*2)
    return height!*scale
}
func ADAPTOR_HEIGHT(height:CGFloat,space:CGFloat = 0)->CGFloat{
    let scale = (KW - space*2)/(320-space*2)
    return height*scale
}
//4s 320*480
//5s 320*568
//6 375*667
//6s 414*736

// 字体
func KMAIN_FONT(name: String = "PingFangSC-Regular" ,size: CGFloat)->UIFont{
    if #available(iOS 9, *){
        return UIFont(name: name, size: size)!
    }
    return UIFont.systemFont(ofSize: size)
}

// 颜色
//let KMAIN_COLOR = UIColor(hex: "0e93e9")
func RGB(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}




func print<N>(msg:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEVELOPMENT
        print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息: \(msg)");
    #endif
}

func isBlank(_ text: String?) -> Bool {
    if let str = text { if !str.isEmpty {  return false}}
    return true
}

// 判读真机/模拟器
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}


