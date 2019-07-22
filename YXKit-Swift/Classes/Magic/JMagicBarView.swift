//
//  JMagicBarView.swift
//  test
//
//  Created by 顾玉玺 on 2018/5/11.
//  Copyright © 2018年 顾玉玺. All rights reserved.
//

import UIKit

typealias JMagicDidSelectItemAtIndexPathBlock = (Int)->Void

class JMagicBarView: UIView{
  
    // 数据源
    var datasource:[String]?{
        didSet{
            collectionView.reloadData()
        }
    }
    // 文字选中的颜色
    var selectedTitleColor = UIColor.red
    
    // 文字正常的颜色
    var normalTitleColor = UIColor.black
    
    // 正在选中的索引
    var selectedIndex = 0
    
    // 选中文字时, 是否放大, 放大比例为1.2
    var scaled = false
    
    // 布局是, 是否平分view大小, 默认为true, 否则文字自适应大小
    var average = true
    
    // 是否隐藏下划线, 默认为false
    var isHiddenSelectedLine = false
    
    // item之间的间距, 默认为0
    var minimumInteritemSpacing: CGFloat = 0.0
    
    // 文字距离item 的左|右间隙
    var textInteritemSpacing: CGFloat = 12;
    
    // 线颜色
    var lineColor = UIColor.white
    
    // 选中的回调
    var didSelectItemAtIndexPath: JMagicDidSelectItemAtIndexPathBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = self.minimumInteritemSpacing
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(JMagicBarCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView;
    }()
    
}

extension JMagicBarView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let ds = self.datasource {
            if self.average{
                return CGSize(width: (self.frame.width - self.minimumInteritemSpacing*CGFloat(ds.count-1))/CGFloat(ds.count), height: self.frame.height)
            }else{
                let title: String = ds[indexPath.row]
                let size = title.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:frame.height),
                                              options: .usesLineFragmentOrigin,
                                              attributes: [.font: UIFont.systemFont(ofSize: 15)],
                                              context: nil).size
                return CGSize(width: size.width + textInteritemSpacing*2, height: self.frame.height)
            }
        }else{
            return CGSize.zero
        }
       
    }
    
    // section 之间的间隙
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // item 之间上下的最小间隙
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // item 之间左右的最小间隙
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! JMagicBarCell
        cell.title.text = datasource?[indexPath.row]
        cell.line.backgroundColor = lineColor;
        if indexPath.row ==  self.selectedIndex{
            select(cell: cell)
        }else{
            normal(cell: cell)
        }
//        didSelectItem(index: self.selectedIndex)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    
    /// 正常的cell 的样式
    ///
    /// - Parameter cell: cell
    func normal(cell: JMagicBarCell) {
        cell.title.textColor = self.normalTitleColor
        cell.title.transform = CGAffineTransform.identity
        cell.line.isHidden = !self.isHiddenSelectedLine
    }
    
    // 选中cell 的样式
    func select(cell: JMagicBarCell) {
        cell.title.textColor = self.selectedTitleColor
        cell.title.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        cell.line.isHidden = false
    }
    
    /// 选中item 做的处理
    ///
    /// - Parameters:
    ///   - collectionView: collectionview
    ///   - index: indexPath.row
    func didSelectItem(index: Int,_ callBack: Bool = true) {
        if self.selectedIndex == index{
            return
        }
        
        print("selected: \(index)");
        
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
        defer {
            self.selectedIndex = index
            if let bolck = didSelectItemAtIndexPath ,callBack{
                bolck(index)
            }
        }
        UIView.animate(withDuration: 0.25) {
            if let cell = (self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as?JMagicBarCell){
                self.select(cell: cell)
            }

            if let maskCell = (self.collectionView.cellForItem(at: IndexPath(item: self.selectedIndex, section: 0))as?JMagicBarCell){
                self.normal(cell: maskCell)

            }
        }
    }
}

class JMagicBarCell: UICollectionViewCell {
    
    lazy var title: UILabel = {
        let lable = UILabel(frame: self.contentView.bounds)
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .center;
        return lable;
    }()
    lazy var line: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2))
        line.backgroundColor = UIColor.white
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.orange
        contentView.addSubview(title)
        contentView.addSubview(line)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

