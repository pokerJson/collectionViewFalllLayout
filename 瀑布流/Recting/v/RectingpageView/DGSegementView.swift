//
//  DGSegementView.swift
//  很划算的看法哈克水电费
//
//  Created by dzc on 2021/6/8.
//

import UIKit
/// 移动方向
enum DGMoveDirection {
    case left   //左移
    case right   //右移
}
@objc class DGSegementView: UIView {

    private var handle: ((Int) -> ())?
    private var titles = [String]()
    private var controllers = [UIViewController]()
    private weak var parentVc: UIViewController!
    
    fileprivate var startOffsetX:CGFloat = 0
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    //pageTitleView
    private lazy var pageTitleView: DGsegementTileView = {
        let pageTitleView = DGsegementTileView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 28), titles: self.titles)
        pageTitleView.backgroundColor = .peogooLighterGray
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    //collectionView
    private lazy var collectionView: UICollectionView = {
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height - 28)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection:UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 28, width: layout.itemSize.width, height: layout.itemSize.height), collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collection.scrollsToTop = false
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        return collection
        
    }()
    @objc public func scrollViewToFirst(){
        currentIndex = 0
        let indexPath = IndexPath(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageTitleView.pageViewScrollEnd(pageIndex: currentIndex)
    }
    public func setScrollViewNoScroll(){
        collectionView.isScrollEnabled = false
    }
   @objc  public func scrollViewToTheIndexPage(index: Int){
        currentIndex = index
        let indexPath = IndexPath(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageTitleView.pageViewScrollEnd(pageIndex: currentIndex)
    }
    @objc init(frame: CGRect,
         titles: [String],
         childControllers: [UIViewController],
         parentController: UIViewController,
         currentIndex: Int = 0,
         loadIndex: @escaping (Int) -> ()){
        
        super.init(frame: frame)
        
        self.titles = titles
        self.controllers = childControllers
        self.parentVc = parentController
        self.handle = loadIndex
        self.handle?(currentIndex)
        //初始化UI
        setupUI()
        //根据传进来的currentIndex确定
        let indexPath = IndexPath(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageTitleView.pageViewScrollEnd(pageIndex: currentIndex)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        //初始化顶部title
        addSubview(pageTitleView)
        
        //初始化CollectionView
        addSubview(collectionView)
    }
    
    //改变title的背景色
    @objc public func configureTitleBackGroColor(color: UIColor) {
        pageTitleView.backgroundColor = color
    }
}

extension DGSegementView : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = controllers[indexPath.row]
        vc.view.frame = cell.contentView.bounds
        cell.contentView .addSubview(vc.view)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbideScroll = false
       
        startOffsetX = scrollView.contentOffset.x
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if startOffsetX == scrollView.contentOffset.x { return }
        if isForbideScroll { return}
        
        var progress: CGFloat = 0
        var targetIndex = 0
        var sourceIndex = 0
        var direction: DGMoveDirection = .left
        
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) / scrollView.frame.width
        if progress == 0 || progress.isNaN {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        if collectionView.contentOffset.x > startOffsetX { // 左滑动
            sourceIndex = index
            targetIndex = index + 1
            guard targetIndex < controllers.count else { return }
            direction = .left
        } else {
            direction = .right
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        }
        
        if progress > 0.998 {
            progress = 1
        }
        pageTitleView.pageViewScroll(direction: direction,sourceIndex:sourceIndex,nextIndex: targetIndex, progress: progress)
    }
    
    //计算currentIndex
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        //拖动结束 计算index
        var index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        let width = scrollView.bounds.size.width
        let count = Int(scrollView.contentSize.width/width)
        if index < 0{
            index = 0
        }
        if index > count - 1 {
            index = count - 1
        }
//        设置viewFrame
        currentIndex = index
        //让pageView滚动起来
        pageTitleView.pageViewScrollEnd(pageIndex: index)
        self.handle?(currentIndex)
    }
}

extension DGSegementView : DGsegementTileViewDelegate{
    
    func pageView(pageView: DGsegementTileView, selectIndex: Int) {
        isForbideScroll = true
        //设置view frame
        currentIndex = selectIndex
        //让collectionView滚动
        let indexPath = IndexPath(row: selectIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        self.handle?(currentIndex)
    }
    
    
}
