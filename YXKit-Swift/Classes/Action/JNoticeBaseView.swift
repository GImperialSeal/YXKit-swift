//
//  JActionBaseView.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/5/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit



public extension JNoticeBaseView{
    
    /// show ActivityIndicatorView
    ///
    /// - Parameters:
    ///   - gif: 动图
    ///   - text: 文字
    ///   - view: 父视图
    public class func showActivityIndicatorView(gif: [UIImage]? = nil,_ text: String? = nil, in view: UIView? = nil){
        let sv = JNoticeBaseView.notice.returnSuperView(view)
        // 默认不能点击
        JNoticeBaseView.notice.shadeStyle = .clear(isUserInteractionEnabled: true, remove: false)
        let activityView = JNoticeActivityIndicatorView(sv: sv, gifs: gif, text: text)
        activityView.center = sv.center
        JNoticeBaseView.notice.show(superView: sv, content: activityView, .center, true)
    }
    
    public class func showText(_ text: String? = nil, in view: UIView? = nil){
        // 默认不能点击
        JNoticeBaseView.notice.shadeStyle = .clear(isUserInteractionEnabled: true, remove: false)
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.numberOfLines = 0
        label.text = text
        label.textAlignment = .center
        let sv = JNoticeBaseView.notice.returnSuperView(view)
        let size = label.sizeThatFits(sv.frame.insetBy(dx: 20, dy: 20).size)
        label.bounds = CGRect.init(x: 0, y: 0, width: size.width + 20, height: size.height+20)
        label.center = JNoticeBaseView.notice.returnSuperView(view).center
        JNoticeBaseView.notice.show(superView: view, content: label, .center, false)
    }
    
    public class func showTableView<T>(titles: [T],selectedTitle: T){
        let w = UIApplication.shared.keyWindow!.bounds.width;
        let h = UIApplication.shared.keyWindow!.bounds.height;
        
        let t = JNoticeTableView(frame: CGRect(x: 0, y: h-CGFloat(44*titles.count+10 + 88 + 44), width: w, height: CGFloat(44*titles.count+10 + 88 + 44)), titles: titles, selectedTitle)
        let titleView =  UIButton(type: .custom)
        titleView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 88)
        titleView.setTitle("标题", for: .normal)
        t.headerView = titleView
        
        let footerView =  UIButton(type: .custom)
        footerView.backgroundColor = UIColor.yellow
        footerView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 44)
        footerView.setTitle("取消", for: .normal)
        t.footerView = footerView
        
        JNoticeBaseView.notice.shadeStyle = .black(isUserInteractionEnabled: true, remove: true)
        JNoticeBaseView.notice.show(superView: nil, content: t, .bottom, true)
    }
        
}


/// 弹出方向
public enum JNoticePopupDirection: Int {
    case bottom
    case left
    case top
    case right
    case center
}

/// 背景层的样式
public enum JNoticeShadeStyle{
    case black(isUserInteractionEnabled: Bool,remove: Bool)
    case clear(isUserInteractionEnabled: Bool,remove: Bool)
    
    var color: UIColor{
        switch self {
        case .clear( _):
            return UIColor.clear
        default:
            return UIColor.black
        }
    }
    // 是否允许用户点击背景
    var isUserInteractionEnabled: Bool{
        switch self {
        case .black(let isUserInteractionEnabled, _),
             .clear(let isUserInteractionEnabled, _):
            return isUserInteractionEnabled
        }
    }
    
    // 点击背景, 是否相应手势执行移除动画
    var remove: Bool{
        switch self {
        case .clear(_ ,let remove),
             .black(_ ,let remove):
            return remove
        }
    }
}

public typealias CompletionBlock = ()->Void

public class JNoticeBaseView: UIView {
    
    // 单利
    static let notice = JNoticeBaseView()
    
    // 弹出方向
    var direction: JNoticePopupDirection = .center
    
    // 内容视图
    var contentView: UIView!
    
    // 动画时间
    var duration: TimeInterval = 0.25
    
    // 遮罩层
    lazy var shadeView: UIView = {
       var shade = UIView(frame: self.bounds)
        shade.backgroundColor = UIColor.black
        shade.alpha = 0
//        shade.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enventForDismiss)))
        return shade
    }()
//    // 点击背景图, 是否执行dimiss
//    var tapShadeToRemove: Bool = true
    
    // 默认为黑色, 可点击
    var shadeStyle = JNoticeShadeStyle.black(isUserInteractionEnabled: true, remove: true){
        didSet{
            self.shadeView.backgroundColor = shadeStyle.color
            self.shadeView.isUserInteractionEnabled = shadeStyle.isUserInteractionEnabled
        }
    }
    
    @objc private func enventForDismiss() {
//        if shadeStyle.remove {
            dimiss(animated: true, delay: 0)
//        }
    }
    
    func transformForContentView() {
        switch self.direction {
        case .top:
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.frame.height)
        case .bottom:
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
        case .left:
            self.contentView.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: 0)
        case .right:
            self.contentView.transform = CGAffineTransform(translationX: -self.contentView.frame.width, y: 0)
        default:
            self.contentView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3);
        }
    }
    
    func animated(animated: Bool, delay: TimeInterval, complete: CompletionBlock? = nil) {
        if animated{
            transformForContentView()
            UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                self.shadeView.alpha = 0.5
                self.contentView.transform = CGAffineTransform.identity
            }) { (finish) in
                if let block = complete{ block()}
            }
        }else{
            self.shadeView.alpha = 0.5
            if let block = complete{ block()}
        }
    }
    
    class func dimiss(animated: Bool, delay: TimeInterval, complete: CompletionBlock? = nil){
        JNoticeBaseView.notice.dimiss(animated: animated, delay: delay, complete: complete)
    }
    
    func dimiss(animated: Bool, delay: TimeInterval, complete: CompletionBlock? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                self.shadeView.alpha = 0
                self.transformForContentView()
            }) { (finish) in
                self.dimissComplete(finish: complete)
            }
        }else{
           self.dimissComplete(finish: complete)
        }
    }
    
    func dimissComplete(finish: CompletionBlock?){
        self.contentView.removeFromSuperview()
        self.shadeView.removeFromSuperview()
        self.removeFromSuperview()
        if let block = finish{ block()}
    }
    

    func show(superView: UIView? = nil,content: UIView, _ direction: JNoticePopupDirection = .bottom , _ animated: Bool = true){
        let sv = returnSuperView(superView)
        sv.addSubview(self)
        self.frame = sv.bounds
        shadeView.frame = sv.bounds
        self.contentView = content
        self.direction = direction
        self.addSubview(shadeView)
        self.addSubview(content)
        self.animated(animated: animated, delay: 0)
    }
    
    /// 判断父视图是否存在, 不存在则使用 默认视图
    ///
    /// - Parameter superView: 父视图
    /// - Returns: 父视图
    private func returnSuperView(_ superView: UIView?)->UIView{
        var sv: UIView!
        if let v = superView {
            sv = v
        }else{
            sv = UIApplication.shared.keyWindow!
        }
        return sv
    }
    
}
