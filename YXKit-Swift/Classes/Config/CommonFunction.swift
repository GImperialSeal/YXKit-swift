//
//  CommonFunction.swift
//  HLShare
//
//  Created by HLApple on 2018/1/25.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import Foundation
import StoreKit
//验证 邮箱网址手机号码等正则判断 使用方法如下
//Validate.email("Dousnail@@153.com").isRight //false
//Validate.URL("https://www.baidu.com").isRight //true
//Validate.IP("11.11.11.11").isRight //true


extension CommonTools{
    enum Validate {
        case email(_: String)
        case phoneNum(_: String)
        case carNum(_: String)
        case username(_: String)
        case password(_: String)
        case nickname(_: String)
        case url(_: String)
        case ip(_: String)
        
        var isRight: Bool {
            var predicateStr:String!
            var currObject:String!
            switch self {
            case let .email(str):
                predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                currObject = str
            case let .phoneNum(str):
                predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
                currObject = str
            case let .carNum(str):
                predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
                currObject = str
            case let .username(str):
                predicateStr = "^[A-Za-z0-9]{6,20}+$"
                currObject = str
            case let .password(str):
                predicateStr = "^[a-zA-Z0-9]{6,20}+$"
                currObject = str
            case let .nickname(str):
                predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
                currObject = str
            case let .url(str):
                predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
                currObject = str
            case let .ip(str):
                predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
                currObject = str
            }
            let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
            return predicate.evaluate(with: currObject)
        }
    }

}


class CommonTools {
   
}

// MARK:获取版本和本机信息（设备、型号)
///类型 0 =   CFBundleShortVersionString    1 = CFBundleVersion 默认获取0
extension CommonTools{
   
    static func GetVersion(_ type:Int=0)->String{
        let infoDictionary = Bundle.main.infoDictionary
        var  Version:String = ""
        if(type==0){
            
            let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject?
            Version=majorVersion as! String
        }
        if(type==1){
            let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"] as AnyObject?
            Version=minorVersion as! String
        }
        return Version
    }
    ///ios 版本
    static  let Iosversion : NSString = UIDevice.current.systemVersion as NSString
    ///设备 udid
    static  let IdentifierNumber = UIDevice.current.identifierForVendor
    /// 设备名称
    static  let SystemName = UIDevice.current.systemName
    /// 设备型号
    static let Model = UIDevice.current.model
    /// 设备区域化型号 如 A1533
    static let LocalizedModel = UIDevice.current.localizedModel
}
// MARK:获取手机设备型号  4s 5 5s 6 6p
/// 获取手机设备型号
extension CommonTools{
    
    static func GetPhoneDeviceModel ()->CommonPhoneDeviceModel{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return  CommonPhoneDeviceModel.iPodTouch5
        case "iPod7,1":                                 return CommonPhoneDeviceModel.iPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return CommonPhoneDeviceModel.iPhone4
        case "iPhone4,1":                               return CommonPhoneDeviceModel.iPhone4s
        case "iPhone5,1", "iPhone5,2":                  return CommonPhoneDeviceModel.iPhone5
        case "iPhone5,3", "iPhone5,4":                  return CommonPhoneDeviceModel.iPhone5c
        case "iPhone6,1", "iPhone6,2":                  return CommonPhoneDeviceModel.iPhone5s
        case "iPhone6,3", "iPhone6,4":                  return CommonPhoneDeviceModel.iPhone5se
        case "iPhone7,2":                               return CommonPhoneDeviceModel.iPhone6
        case "iPhone7,1":                               return CommonPhoneDeviceModel.iPhone6Plus
        case "iPhone8,1":                               return CommonPhoneDeviceModel.iPhone6s
        case "iPhone8,2":                               return CommonPhoneDeviceModel.iPhone6sPlus
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return CommonPhoneDeviceModel.iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return CommonPhoneDeviceModel.iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return CommonPhoneDeviceModel.iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return CommonPhoneDeviceModel.iPadAir
        case "iPad5,3", "iPad5,4":                      return CommonPhoneDeviceModel.iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":           return CommonPhoneDeviceModel.iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return CommonPhoneDeviceModel.iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return CommonPhoneDeviceModel.iPadMini3
        case "iPad5,1", "iPad5,2":                      return CommonPhoneDeviceModel.iPadMini4
        case "iPad6,7", "iPad6,8":                      return CommonPhoneDeviceModel.iPadPro
        case "AppleTV5,3":                              return CommonPhoneDeviceModel.AppleTV
        case "i386", "x86_64":                          return CommonPhoneDeviceModel.Simulator
        default:                                        return CommonPhoneDeviceModel.processor
        }
        
    }
}
//获取手机型号 5s 6 6p 6ps等
enum CommonPhoneDeviceModel : String {
    case iPodTouch5; case iPodTouch6
    case iPhone4;case iPhone4s
    case iPhone5;case iPhone5c; case iPhone5s ;case iPhone5se
    case iPhone6 ;case iPhone6Plus
    case iPhone6s ;case iPhone6sPlus
    case iPad2 ;case iPad3; case iPad4
    case iPadAir ;case iPadAir2
    case iPadMini ;case iPadMini2;case iPadMini3;case iPadMini4
    case iPadPro;case AppleTV;case Simulator;case  processor
}

// MARK:应用跳转
/// 跳转到相应的应用，记得将 http:// 替换为 itms:// 或者 itms-apps://：  需要真机调试

extension CommonTools{
    static func OpenAppStore(_ vc:UIViewController,url: String){
        //在url内查找appid
        if let number = url.range(of: "[0-9]{9}", options: NSString.CompareOptions.regularExpression) {
//            let appId = url.substring(with: number)
            let appId = url[number]
            let productView = SKStoreProductViewController()
            productView.delegate = vc as? SKStoreProductViewControllerDelegate
            productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appId], completionBlock: {  (result, error) -> Void in
                if !result {
                    //点击取消
                    productView.dismiss(animated: true, completion: nil)
                }
            })
            vc.present(productView, animated: true, completion: nil)
        } else {
//            HUD("打开失败,请查看url是否正确", type: .error)
        }
    }
    
    /// 拨打电话 ,里面会判断是否需要拨打号码 外部不需要调用判断 需要真机调试
    static func CallPhone(number:String){
        //确定
        let telUrl="tel:"+number
        let url  = URL(string: telUrl)
        UIApplication.shared.openURL(url!)
        
    }
    
    /// 打开浏览器    需要真机调试
    static func OpenBlogForBrowser(_ url:String){
        UIApplication.shared.openURL(URL(string: url)!)
    }
}

// MARK: >> 生成二维码
/**
 生成二维码
 
 - parameter qrString:    字符串
 - parameter qrImageName: 图片
 
 - returns: uiiamge
 */
extension CommonTools{
    
    static func CreateQRCode(_ qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter!.setValue(stringData, forKey: "inputMessage")
            qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter!.outputImage
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter!.setDefaults()
            colorFilter!.setValue(qrCIImage, forKey: "inputImage")
            colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
//            let codeImage = UIImage(ciImage: colorFilter!.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
            let codeImage = UIImage(ciImage: colorFilter!.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))

            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }

}

