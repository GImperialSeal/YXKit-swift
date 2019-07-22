//
//  JToolBarInputView.swift
//  GMKit
//
//  Created by 顾玉玺 on 2018/6/20.
//

import Foundation

let toolBarMaxLines = 5

let spaceH: CGFloat = 8

let spaceL: CGFloat = 12

let textViewFont: CGFloat = 15

public class ToolBarInput: UIView, UITextViewDelegate {
    
    lazy var textView: UITextView = {
        let t = UITextView(frame: CGRect(x: spaceL, y: spaceH, width: KW-spaceL*2, height: 44))
        t.backgroundColor = UIColor.white
        t.returnKeyType = .send
        t.font = UIFont.systemFont(ofSize: 15)
        t.delegate = self
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.layer.borderWidth = 0.5
        t.addObserver(self, forKeyPath: "contentSize", options: [.old,.new], context: nil)
        return t
    }()
    
    lazy var placeHolder: UILabel = {
        let p = UILabel(frame: self.textView.frame.insetBy(dx: 5, dy: 0))
        p.font = textView.font
        p.numberOfLines = 1
        p.textColor = UIColor(red: 72/256, green: 82/256, blue: 93/256, alpha: 1)
        return p
    }()
    
    var tableView: UITableView!

    private lazy var tap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(eventForTap))
        return t
    }()
    
    
    private var keyboardH: CGFloat = 0
    
    private var singleLineHeight: CGFloat{
        return CGFloat(floorf(Float(UIFont.systemFont(ofSize: 15.0).lineHeight)))
    }
    
    private var textViewH: CGFloat{
        return singleLineHeight + 17
    }
    
    private var toolbarH: CGFloat{
        return textViewH + spaceH * 2
    }
    
    @objc func eventForTap(){ textView.resignFirstResponder() }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let oldSize = change![NSKeyValueChangeKey.oldKey] as! CGSize
        let newSize = change![NSKeyValueChangeKey.newKey] as! CGSize
        
        let height = textView.sizeThatFits(CGSize(width: textView.frame.width, height: KH)).height
        
        if max(oldSize.height, newSize.height) <= self.textViewH { return }
        
        if height - CGFloat(toolBarMaxLines) * self.singleLineHeight > 0{ return }
        
        UIView.animate(withDuration: 0.25) {
            self.frame = CGRect.init(x: 0, y: KH - self.keyboardH - (height + spaceH*2), width: KW, height: height + spaceL*2)
            var rect = self.textView.frame
            rect.size.height = height
            self.textView.frame = rect
            
            let offY = newSize.height > oldSize.height ? -self.singleLineHeight : self.singleLineHeight
            
            self.tableView.transform = self.tableView.transform.translatedBy(x: 0, y: offY)
        }
        
    }
    
    deinit {
        textView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self)
    }
}


