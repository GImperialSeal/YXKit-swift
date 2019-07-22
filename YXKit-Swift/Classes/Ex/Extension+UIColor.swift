//
//  Extension+UIColor.swift
//  HLShare
//
//  Created by HLApple on 2018/1/22.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import UIKit
import Foundation

extension UIColor{
    ///UIColor 转换 uiimage
    func ImageWithColor(_ color: UIColor) -> UIImage {
        // 描述矩形
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文
        let context: CGContext = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        context.setFillColor(color.cgColor)
        // 渲染上下文
        context.fill(rect)
        // 从上下文中获取图片
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 结束上下文
        UIGraphicsEndImageContext()
        return theImage
    }
    
    ///设置图片透明度
    func ImageByApplyingAlpha(_ alpha: CGFloat, image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        let area: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(image.cgImage!, in: area)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///改变图片大小
    func ImageCompressForWidth(_ sourceImage: UIImage, targetWidth defineWidth: CGFloat) -> UIImage {
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = defineWidth
        let targetHeight: CGFloat = (targetWidth / width) * height
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
  
}
