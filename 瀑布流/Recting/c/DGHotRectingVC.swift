// Copyright © 2021 Peogoo. All rights reserved.

import UIKit

class DGHotRectingVC: UIViewController{
    
    private var hotRectingList = [DGHotRectingModel]()//热门跟读数组
    private var pageNum: Int = 1
//    private var materialIdStr: String?

    private lazy var noDataView = DGNodataView.configForWall(view: self.collectionView,width:kSCREEN_width,height:kSCREEN_height,top: -150)//缺省视图
    
    private lazy var collectionView: UICollectionView = {
        let layout = DGWaterfallFlowLayout()
        layout.delegate = self
        let result = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.kSCREEN_width, height: self.kSCREEN_height - self.kNAVBARH - 28), collectionViewLayout: layout)
        result.backgroundColor = .peogooLighterGray
        result.delegate = self
        result.dataSource = self
        result.alwaysBounceVertical = true
        result.register(DGCustomRectingCell.self, forCellWithReuseIdentifier: "CELL")
        result.mj_footer = DGRefresh.instance().tpe_refreshFooterHandler(self, refreshCallBack: { [unowned self] in
            self.pageNum += 1
            self.getHotRectingData()
        })
        self.kCollectView = result
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .peogooLighterGray
        view.addSubview(collectionView)
//        getHotRectingData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func kSubVCViewWillAppear() {
        print("下拉刷新1")
        pageNum = 1
        getHotRectingData()
    }
//    override func kSubVCViewWillAppearLoadWitId(_ materialId: String) {
//        materialIdStr = materialId
//        pageNum = 1
//        getHotRectingData()
//    }
    //MARK:获取热门跟读
    private func getHotRectingData(){
        
        DGServer.getHotRectingData(pageN: pageNum,materialId: materialIdStr ).onSuccess { [weak self] hotRectinglistModel in
            guard let self = self else { return }
            self.collectionView.mj_footer.endRefreshing()

            guard self.pageNum != 1 else {
                //第一页
                self.hotRectingList.removeAll()
                if let list = hotRectinglistModel.list,list.isEmpty == false {
                    //有数据
                    self.noDataView.isHidden = true
                    self.hotRectingList.append(contentsOf: list)
                    self.collectionView.reloadData()
                    if self.pageNum == hotRectinglistModel.totalPage {
                        self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }else{
                    self.noDataView.isHidden = false
                }
                return
            }
            //上拉加载的数据
            if let list = hotRectinglistModel.list,list.isEmpty == false {
                self.hotRectingList.append(contentsOf: list)
            }else{
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            if self.pageNum == hotRectinglistModel.totalPage {
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.collectionView.reloadData()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == collectionView) {
            if (!self.scrollEnabled) {
                scrollView.contentOffset = .zero;
            }
            if (scrollView.contentOffset.y <= 0) {
                self.scrollEnabled = false;
                scrollView.contentOffset = .zero;
                NotificationCenter.default.post(name: Notification.Name("RectingLeaveTop"), object: nil)
            }
        }
    }
}
extension DGHotRectingVC: WaterfallMutiSectionDelegate{
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        return hotRectingList[indexPath.row].cellHeight
    }
    
    func columnNumber(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> Int {
        return 2
    }
    func insetForSection(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func lineSpacing(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> CGFloat {
      return 12
    }
    
    func interitemSpacing(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> CGFloat {
      return 13
    }
    
    func spacingWithLastSection(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> CGFloat {
      return 15
    }
}
extension DGHotRectingVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotRectingList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! DGCustomRectingCell
        cell.fillData(model: hotRectingList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击的是-->\(indexPath.row)")

        let vc = DGRectingDetailVC(nodeId: hotRectingList[indexPath.row].iid,isFromHotOrNewRecting: true)
        vc.from = .othersRecting
        dg_Push(vc, animated: true)
        
    }
}
