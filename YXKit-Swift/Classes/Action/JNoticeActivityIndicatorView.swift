//
//  JNoticeActivityIndicatorView.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/5/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit


class JNoticeActivityIndicatorView: UIToolbar {
    // gif图数组, 如果图片是1张就旋转, 多张用帧动画
    var gif:[UIImage]?
    
    static var timerTimes = 0
    
    // 距离上下左右的距离
    var margin: CGFloat = 20;

    // 标题
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = KMAIN_FONT(size: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    // gif容器
    lazy var customActivictView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = gif?.first
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 旋转动画
    lazy var rotationAnimation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = 2 * Double.pi
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        return anim
    }()
    // 计时器
    lazy var timer: DispatchSource = {
        var timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as! DispatchSource
        timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(0))
        timer.setEventHandler(handler: { () -> Void in
            let img = self.gif![JNoticeActivityIndicatorView.timerTimes % self.gif!.count]
            self.customActivictView.image = img
            JNoticeActivityIndicatorView.timerTimes += 1
        })
//        timer.resume()
        return timer
    }()
    
    // 活动指示器
    lazy var activityView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.frame = CGRect(x: self.margin, y: self.margin, width: 36, height: 36)
        ai.startAnimating()
        return ai
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.barStyle = .black
        
    }
    
    convenience init(sv: UIView, gifs:[UIImage]?, text: String?) {
        self.init(frame: CGRect.zero)
        self.gif = gifs
        
        var tempActivity: UIView!
        // 若果gif图存在
        if let images = gifs, images.count>0 {
            addSubview(customActivictView)
            let size = images.first!.size
            customActivictView.frame = CGRect(x: margin, y: margin, width: size.width, height: size.height)
            if images.count == 1{
                customActivictView.layer.add(rotationAnimation, forKey: nil)
            }else{
                timer.resume()
            }
            tempActivity = customActivictView;
        }else{
            // 使用系统的
            addSubview(activityView)
            tempActivity = activityView;
        }
        
        let y =  tempActivity.frame.maxY
        
        let activityWidth =  tempActivity.frame.width
        
        self.bounds = CGRect.init(x: 0, y: 0, width: activityWidth + self.margin*2, height: y + self.margin)
        
        // 如果有文字
        if let t = text,t.count>0 {
            addSubview(title)
            title.text = t
            
            let size = title.sizeThatFits(CGSize(width: sv.frame.width-self.margin*4, height: .greatestFiniteMagnitude))
            
            let width =  size.width > activityWidth ? size.width : activityWidth
            
            title.frame = CGRect.init(x: self.margin, y: y + 8, width: width, height: size.height)
            
            self.bounds = CGRect.init(x: 0, y: 0, width: width + self.margin*2, height: title.frame.maxY + self.margin)
            
            tempActivity.center.x = self.bounds.width/2
        }
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
