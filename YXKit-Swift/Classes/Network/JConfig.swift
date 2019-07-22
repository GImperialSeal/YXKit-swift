//
//  config.swift
//  LuCommandLine
//
//  Created by Brave Lu on 2018/1/1.
//  Copyright © 2018年 Brave Lu. All rights reserved.
//

import Foundation

class JConfig {
    
    /* 如果需要适配 iOS 10，请在info.plist中加入如下字段
     * NSCameraUsageDescription -->  我们需要使用您的相机
     * NSPhotoLibraryUsageDescription --> 我们需要访问您的相册
     * 如不添加该字段，在iOS 10环境下会直接崩溃
     */
    
    #if DEVELOPMENT
    // 测试环境
//    static let BASE_URL = "http://47.100.14.37:8080/"
    static let BASE_URL = "http://192.168.1.113:8080/"
    static let BMK_SERVICES_API_KEY = "cwNpkGIfzzcxDB66mRYGc4yNCPAhijld"
    static let HYPHENATELITE_API_KEY = "aa1c2e092bdd44cfc02b1d80d52869ac"
    #else
    // 开发环境
    static let BASE_URL = "http://47.100.14.37:8080/"
    //static let BASE_URL = "http://192.168.1.113:8090/"
    static let BMK_SERVICES_API_KEY = "cwNpkGIfzzcxDB66mRYGc4yNCPAhijld"
    static let HYPHENATELITE_API_KEY = "aa1c2e092bdd44cfc02b1d80d52869ac"
    
    #endif
    
    /// 可接收类型
    static let contentType: Set<String> = ["application/json",
                                            "text/html",
                                            "text/javascript",
                                            "image/jpeg",
                                            "application/x-zip-compressed"]
			
	static var token : String = "12345678"
	
	static func getToken() -> String {
		if let t = UserDefaults.standard.value(forKey: "token") {token = t as! String}
		else {token = ""}
		return token
	}
	
	static func saveToken(_ token : String) {
		//self.token = "12333333"
		self.token = token
		UserDefaults.standard.set(token, forKey: "token")
	}
	

}
