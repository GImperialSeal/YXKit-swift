//
//  JActionTableView.swift
//  GMKit_Example
//
//  Created by 顾玉玺 on 2018/5/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class JNoticeTableView<T>: UIView,UITableViewDelegate,UITableViewDataSource{
    
    typealias JSelectedFinishedBlcok = (T)->Void
    
    var rowH: CGFloat = 44
    var style = UIBarStyle.default
    var tableFooterH: CGFloat = 10.0
    var translucent = true
    var dataSource:[T]!
    var selectedData:T?
    var selectedFinishedBlock: JSelectedFinishedBlcok?
    var headerView: UIView?
    var footerView: UIView?

    lazy var backView: UIToolbar = {
        var v = UIToolbar(frame: self.bounds)
        v.barStyle = self.style
        return v
    }()
    
    lazy var tableView: UITableView = {
        var tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = self.rowH
        tv.sectionFooterHeight = self.tableFooterH
        tv.sectionHeaderHeight = 0.5
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, titles:[T],_ selectedTitle: T) {
        self.init(frame: frame)
        self.dataSource = titles
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var footerSize = CGSize.zero
        
        var headerSize = CGSize.zero
        
        if translucent {
            addSubview(self.backView)
        }
        
        if let v = headerView {
            addSubview(v)
            headerSize = v.frame.size
            v.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: headerSize.height)
        }
        
        if let v = footerView {
            addSubview(v)
            footerSize = v.frame.size
        }
        
        addSubview(tableView)
        
        tableView.frame = CGRect(x: 0, y: headerSize.height, width: self.frame.width, height: self.frame.height - headerSize.height - footerSize.height)
        
        if let v = footerView {
            v.frame = CGRect(x: 0, y: tableView.frame.maxY, width: frame.width, height: footerSize.height)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = dataSource[indexPath.row]
        tableView.reloadData()
        JNoticeBaseView.dimiss(animated: true, delay: 0.25) {
            if let block = self.selectedFinishedBlock{
                block(self.selectedData!)
            }
        }
    }
}


