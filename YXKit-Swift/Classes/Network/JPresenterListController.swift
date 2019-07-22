//
//  File.swift
//  HLShare
//
//  Created by HLApple on 2018/1/19.
//  Copyright © 2018年 HLApple. All rights reserved.
//

import Foundation
import UIKit
import ESPullToRefresh

// MARK: - 刷新
extension JPresenterListController{
    /// 下拉刷新
    func pullRefresh() {
        tableView.es.addPullToRefresh {[weak self] in
            self?.refresh = true
            self?.execute()
        }
    }
    
    /// 上拉加载
    func loadMore() {
        tableView.es.addInfiniteScrolling {[weak self] in
            self?.refresh = false
            self?.execute()
        }
    }
    
    
    /// 停止所有刷新动作
    func stopRefresh()  {
        self.tableView.es.stopPullToRefresh(ignoreDate: true)
        self.tableView.es.stopLoadingMore()
    }
    
    // 添加刷新
    func addRefresh()  {
        pullRefresh()
        loadMore()
    }
}


// MARK: - 网络请求
extension JPresenterListController{
    /// 代理方式执行回调
    func execute() {
        querier.pager?.fill(&querier.params)
        defer {
            self.querier.pager?.increase()
        }
        NetworkManager.POST(querier, success: { response in
            if let list = response.entities {
                if self.refresh{
                    self.dataSource = list
                    self.tableView.reloadData()
                }else{
                    /// 计算行数
                    var indexs = [IndexPath]()
                    for i in  0 ..< list.count {
                        let index = IndexPath(row: i + self.dataSource.count, section: 0)
                        print("index: \(index)")
                        
                        indexs.append(index)
                    }
                    /// 添加数据
                    self.dataSource.append(contentsOf: list)
                    /// 刷新指定的行数
                    self.tableView.insertRows(at: indexs, with: .automatic)
                }
            }
            self.stopRefresh()
        }) { (error) in
            self.stopRefresh()
        }
        
    }
}


class JPresenterListController<Element: JResult,R: JListResult<Element>>:
    UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var querier: JQuerier<R>!
    
    // 重用标识符 约定: 重用标识符必须和cell 名字一样
    // 子类需要重写此属性
    var cellIdentifier: String{return "cell"}
    
    /// 数据源
    var dataSource = [Element]()
    
    /** 刷新  true 表示  下拉刷新  false加载更多*/
    private var refresh: Bool = true{
        didSet{
            /// 如果刷新一次, 把分页页器页数归0
            if refresh { querier.pager?.page = 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return self.dataSource.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
 
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.dataSource.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
  
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        return tableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
    
}

