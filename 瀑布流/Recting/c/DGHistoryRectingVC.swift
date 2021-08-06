// Copyright © 2021 Peogoo. All rights reserved.
//历史素材

import UIKit

class DGHistoryRectingVC: UIViewController {
    
    private var historyRectingList = [DGHostoryRectingModel]()//历史素材
    private var pageNum: Int = 1
    private let rectiongId: String
    private lazy var noDataView = DGNodataView.configForWall(view: self.collectionView,width:kSCREEN_width,height:kSCREEN_height,top: 0)//缺省视图
    
    private lazy var collectionView: UICollectionView = {
        let layout = DGWaterfallFlowLayout()
        layout.delegate = self
        let result = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.kSCREEN_width, height: self.kSCREEN_height - self.kNAVBARH), collectionViewLayout: layout)
        result.backgroundColor = .peogooLighterGray
        result.delegate = self
        result.dataSource = self
        result.register(DGHisttoryRectingCell.self, forCellWithReuseIdentifier: "CELL")
        result.mj_header = DGRefresh.instance().tpe_refreshHeaderHandler(self, refreshCallBack: { [unowned self] in
            self.pageNum = 1
            self.getHistoryRectingData()
        })
        result.mj_footer = DGRefresh.instance().tpe_refreshFooterHandler(self, refreshCallBack: { [unowned self] in
            self.pageNum += 1
            self.getHistoryRectingData()
        })
        self.kCollectView = result
        return result
    }()
    init(rectingID: String) {
        self.rectiongId = rectingID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "历史素材"
        view.backgroundColor = .peogooLighterGray
        view.addSubview(collectionView)
        getHistoryRectingData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK:获取历史素材
    private func getHistoryRectingData(){
        
        DGServer.getHistoryRectingData(pageN: pageNum, materialId: rectiongId).onSuccess { [weak self] historyRectinglistModel in
            guard let self = self else { return }
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()

            guard self.pageNum != 1 else {
                //第一页
                self.historyRectingList.removeAll()
                if let list = historyRectinglistModel.list,list.isEmpty == false {
                    //有数据
                    self.noDataView.isHidden = true
                    self.historyRectingList.append(contentsOf: list)
                    self.collectionView.reloadData()
                    if self.pageNum == historyRectinglistModel.totalPage {
                        self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }else{
                    self.noDataView.isHidden = false
                }
                return
            }
            //上拉加载的数据
            if let list = historyRectinglistModel.list,list.isEmpty == false {
                self.historyRectingList.append(contentsOf: list)
            }else{
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            if self.pageNum == historyRectinglistModel.totalPage {
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.collectionView.reloadData()
        }
    }
    
}
extension DGHistoryRectingVC: WaterfallMutiSectionDelegate{
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        return historyRectingList[indexPath.row].cellHeight
    }
    
    func columnNumber(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> Int {
        return 1
    }
    func insetForSection(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
    }
    
    func lineSpacing(collectionView collection: UICollectionView, layout: DGWaterfallFlowLayout, section: Int) -> CGFloat {
      return 12
    }

}
extension DGHistoryRectingVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyRectingList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! DGHisttoryRectingCell
        cell.fillData(model: historyRectingList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击的是-->\(indexPath.row)")
        let vc = DGRectingDetailVC(nodeId: historyRectingList[indexPath.row].recetingID,isFromHotOrNewRecting: false)
        vc.from = .todayRecting
        dg_Push(vc, animated: true)
    }
}
