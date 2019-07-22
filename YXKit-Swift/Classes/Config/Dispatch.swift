//
//  Dispatch.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/5/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation


typealias DelayTask = (_ cancel : Bool) -> Void

typealias CountdownFinished = ()->Void

typealias CountdownRepeating = (String)->Void


/// 倒计时
///
/// - Parameters:
///   - secound: 秒, 默认为60s
///   - completion: 倒计时完成
///   - repeating: 倒计时进行中....
func countdown(secound:Int = 60, completion: @escaping (()->Void),repeating:@escaping ((String)->Void))  {
    var timeCount = secound
    let timer = DispatchSource.makeTimerSource( queue:  DispatchQueue.global())
    timer.schedule(deadline: .now(), repeating: .seconds(1))
    timer.setEventHandler {
        timeCount = timeCount - 1
        if timeCount <= 0 {
            timer.cancel()
            DispatchQueue.main.async {
                //                    sender.setTitle("获取验证码", for: .normal)
                //                    sender.isEnabled = true
                completion()
            }
        }else{
            let text = "\(timeCount % 60)" + "s"
            DispatchQueue.main.async {
                //                    UIView.beginAnimations("", context: nil)
                //                    UIView.setAnimationDuration(1.0)
                //                    sender.setTitle(text, for: .normal)
                //                    UIView.commitAnimations()
                //                    sender.isEnabled = false
                repeating(text)
            }
        }
    }
    timer.resume()
}



/// 延时
///
/// - Parameters:
///   - time: secound
///   - task: task
/// - Returns: delay task
@discardableResult
func delay(_ time: TimeInterval, task: @escaping ()->()) ->  DelayTask?{
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: DelayTask?
    let delayedClosure: DelayTask = { cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancle(_ task: DelayTask?) {
    task?(true)
}
