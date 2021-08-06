// Copyright © 2021 Peogoo. All rights reserved.

import UIKit

class DGRectingVC: UIViewController {

    private var _headHeight: CGFloat = 300
    private var _whichVCIndex: Int = 0
    private var materialId: String?

    private lazy var noDataView = DGNodataView.configForRecting(view: self.bgsSrollView,width:kSCREEN_width,height:kSCREEN_height,top: 0)//缺省视图

    //顶部今日跟读视图
    private lazy var headView: DGRectingHeadView = {
        let result = DGRectingHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: _headHeight))
        result.gotoHistoryHandle = { [weak self] rectingID in
            guard let self = self else { return }
            let his = DGHistoryRectingVC(rectingID: rectingID)
            self.dg_Push(his, animated: true)
        }
        return result
    }()
    //背景滚动视图
    private lazy var bgsSrollView: EPScrollView = {
        let result = EPScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREENT_HEIGHT))
        result.delegate = self
        result.addSubview(self.headView)
        result.addSubview(self.pageView)
        result.showsVerticalScrollIndicator = false
        result.backgroundColor = .peogooLighterGray//解决下拉刷新 背景颜色白色
        result.mj_header = DGRefresh.instance().tpe_refreshHeaderHandler(self, refreshCallBack: { [unowned self] in
            self.getTodayReading()
//            self.vcs[self._whichVCIndex].kSubVCViewWillAppearLoadWitId(self.materialId ?? "")
            self.vcs[self._whichVCIndex].kSubVCViewWillAppear()
        })
        return result
    }()
    private var vcs = [DGHotRectingVC(),DGNewRectingVC()]
    private lazy var pageView: DGSegementView = {
        let result = DGSegementView(frame: CGRect(x: 0, y: _headHeight, width: SCREEN_WIDTH, height: SCREENT_HEIGHT - kNAVBARH), titles: ["热门跟读","最新跟读"], childControllers: children, parentController: self, currentIndex: 0) { [weak self] (index) in
            guard let self = self else { return }
            self._whichVCIndex = index
        }
        result.backgroundColor = .peogooLighterGray
        return result
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "吟诵"
        navigationController?.navigationBar.isHidden = false;
        navigationController?.isNavigationBarHidden = false;
        navigationController?.navigationBar.barTintColor = .peogooLighterGray
        self.scrollEnabled = true
        vcs.forEach { (vc) in
            addChild(vc)
        }
        view.addSubview(bgsSrollView)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollStatusMethod), name: Notification.Name("RectingLeaveTop"), object: nil)

        getTodayReading()
    }
    deinit {
      print(">>>>>>>>> \(self) is 释放了 <<<<<<<")
    }
    //MARK:获取今日素材
    private func getTodayReading(){
        
        DGServer.queryTodayRecting().onSuccess { [weak self] dict in
            guard let self = self else { return }
            self.bgsSrollView.mj_header.endRefreshing()
            if dict["data"] is NSNull {
                self.noDataView.isHidden = false
                return
            }
            let model = DGRectingHeadModel.mj_object(withKeyValues: dict["data"])
            guard let headModele = model else { return }
            
            self.materialId = headModele.recetingID
            self.vcs.forEach { (vc) in
                //全部刷新
                vc.materialIdStr = self.materialId ?? ""
                vc.kSubVCViewWillAppear()
            }
//            self.vcs[self._whichVCIndex].kSubVCViewWillAppearLoadWitId(self.materialId ?? "")

            self.headView.height_ = headModele.headViewHeight
            self.headView.fillData(model: headModele)
            self.pageView.y_ = headModele.headViewHeight
            self._headHeight = headModele.headViewHeight
            self.noDataView.isHidden = true
            DispatchQueue.main.async {//解决数据少滑不到顶部
                self.bgsSrollView.contentSize = CGSize(width: self.kSCREEN_width, height: self.kSCREEN_height + headModele.headViewHeight)
            }
        }.onError { er in
            self.bgsSrollView.mj_header.endRefreshing()
            self.noDataView.isHidden = false
        }
        
    }

}
extension DGRectingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bgsSrollView {
            let topHeigth:CGFloat = _headHeight
            if scrollView.contentOffset.y >= topHeigth {
                scrollView.contentOffset = CGPoint(x: 0, y: topHeigth)
                if self.scrollEnabled {
                    self.scrollEnabled = false
                    for vc in vcs {
                        vc.scrollEnabled = true
                    }
                }
            }else{
                if !self.scrollEnabled {
                    scrollView.contentOffset = CGPoint(x: 0, y: topHeigth)
                }
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    @objc func scrollStatusMethod(){
        self.scrollEnabled = true;
        for vc in vcs {
            vc.scrollEnabled = false
            vc.kCollectView?.contentOffset = .zero;
        }
    }
    
    
}
extension DGServer {
   
//    public static func queryTodayRecting() -> Operation<DGRectingHeadModel> {
//
//        return DGServer.execute(.post, .queryTodayRecting, parameters: [:], isJson: false)
//
//    }
    static func queryTodayRecting() -> Operation<[String:Any]> {
        return DGServer.executeAll(.post, .queryTodayRecting,showMessage: false, isJson: false)
    }
    //素材详情
    static func queryDetailRecting(materialId: String,isFromHotNew: Bool) -> Operation<[String:Any]> {
        if isFromHotNew {
//            let str = .queryHotNewDetailRecting + "?id=" + materialId
            
            return DGServer.execute(.post, .queryHotNewDetailRecting,parameters: ["id": materialId] ,showMessage: false, isJson: false)
        }else{
            return DGServer.execute(.post, .queryDetailRecting,parameters: ["materialId": materialId] ,showMessage: false, isJson: true)
        }
//        return DGServer.execute(.post, isFromHotNew ? .queryHotNewDetailRecting : .queryDetailRecting,parameters: isFromHotNew ? ["id": materialId] : ["materialId": materialId],showMessage: false, isJson: isFromHotNew ? false : true)
    }
}
