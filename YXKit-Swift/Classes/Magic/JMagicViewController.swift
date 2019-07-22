//
//  ViewController2.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/29.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit

//fileprivate let KH: CGFloat = UIScreen.main.bounds.height;
//fileprivate let KW: CGFloat = UIScreen.main.bounds.width;

struct TabItemInfo {
    var title: String
    var vc: UIViewController
}

extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
class JMagicViewController: UIViewController {
    private var maskBtn: UIButton!
    var itemInfos:[TabItemInfo]!{
        didSet{
            barView.datasource = itemInfos.map {$0.title};
        }
    }
    var titleNormalColor = UIColor.black // 正常的颜色
    var titleSelectColor = UIColor.red // 选中的颜色
    var defaultSelectIndex: Int = 0 // 默认选中第0个
    
    let topViewHeight: CGFloat = 44.0
    var collectionViewHeight: CGFloat {return self.view.frame.height - topViewHeight}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(barView)
        view.addSubview(collectionView)
    }
   
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: self.view.frame.width, height:collectionViewHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: topViewHeight, width: self.view.frame.width, height: collectionViewHeight), collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView;
    }()
    lazy var barView: JMagicBarView = {
        let bar = JMagicBarView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topViewHeight))
        bar.backgroundColor = UIColor.white
        bar.didSelectItemAtIndexPath = {[weak self] index in
            self?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }
        return bar;
    }()

}

extension JMagicViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let vc = itemInfos[indexPath.row].vc
        if let _ = self.childViewControllers.index(of: vc) {
            print("存在")
        }else{
            vc.view.frame = cell.bounds;
            cell.contentView.addSubview(vc.view)
            self.addChildViewController(vc)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.view.frame.width)
        barView.didSelectItem(index: index, false)
    }

}


