//
//  CycleView.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/2.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit
import Kingfisher

/// 下载图片 Kingfisher 第三方

class CycleView: UIView {
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    //组数 多少组都可以最少三组
    private let MaxSections = 3
    
    private var dataSource = [String]()
    
    /// 选中图片的回调
    var didSelectItemAtIndex :((Int)->Void)?
    
    /// 拖动结束后 3秒开始轮播
    var delineAfterDrag: TimeInterval = 3
    
    /// 添加轮播的图片
    ///
    /// - Parameters:
    ///   - imagesUrl: 图片的地址
    ///   - deadline: 延迟几秒开始轮播  默认3秒后轮播
    func setupCycleDataSource(_ imagesUrl: [String],_ deadline: TimeInterval = 3) {
        self.dataSource = imagesUrl
        self.collectionView.reloadData()
        self.pageControl.numberOfPages = self.dataSource.count
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) {
            self.timer.fireDate = Date()
        }
        //默认滚动到中间的那一组
        //        collectionView.scrollToItem(at: IndexPath(item: 0, section: MaxSections / 2), at: .left, animated: false)
    }
    
    @objc private func nextImage() {
        //获取当前indexPath
        if let currentIndexPath = collectionView.indexPathsForVisibleItems.last {
            //获取中间那一组的indexPath
            let middleIndexPath = IndexPath(item: currentIndexPath.item, section: 1)
            
            //滚动到中间那一组
            collectionView.scrollToItem(at: middleIndexPath, at: .left, animated: false)
            
            var nextItem = middleIndexPath.item + 1
            
            var nextSection = middleIndexPath.section
            
            if nextItem == dataSource.count {
                nextItem = 0
                nextSection += 1
            }
            collectionView.scrollToItem(at: IndexPath(item: nextItem, section: nextSection), at: .left, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    class CycleViewCell: UICollectionViewCell {
        open var url: String?{
            didSet{
                if let url = url {
                    if url.hasPrefix("http"){
                        imageView.kf.setImage(with:URL(string: url))
                    }else{
                        imageView.image = UIImage(named: url);
                    }
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(imageView);
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        private lazy var imageView: UIImageView = {
            let imageView = UIImageView(frame: self.contentView.bounds);
            return imageView;
        }();
        
    }
    
    private lazy var timer: Timer = {
        var t = Timer(timeInterval: 3, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.current.add(t, forMode: .commonModes)
        return t
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 160)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.register(CycleViewCell.self, forCellWithReuseIdentifier: CycleView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20)
        pageControl.pageIndicatorTintColor = UIColor.groupTableViewBackground
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        return pageControl;
    }()
    
}

extension CycleView:  UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MaxSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleView.reuseIdentifier, for: indexPath) as! CycleViewCell
        cell.url = dataSource[indexPath.item];
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选择了第 \(indexPath.row) 张照片")
        didSelectItemAtIndex?(indexPath.row)
    }
    
    //在这个方法中算出当前页数
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + (collectionView.bounds.width) * 0.5) / (collectionView.bounds.width))
        let currentPage = page % dataSource.count
        pageControl.currentPage = currentPage
    }
    
    //在开始拖拽的时候移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.fireDate = Date.distantFuture
    }
    
    //结束拖拽的时候重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delineAfterDrag) {
            self.timer.fireDate = Date()
        }
    }
    
    //手动滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 1), at: .left, animated: false)
    }
    
   
}

