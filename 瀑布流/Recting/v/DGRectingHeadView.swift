// Copyright © 2021 Peogoo. All rights reserved.

import UIKit

class DGRectingHeadView: UIView {

    var gotoHistoryHandle: ObjectClosure<String>?
    private var hModel: DGRectingHeadModel?
    
    private lazy var backView: UIView = {
        let reslut = UIView()
        reslut.backgroundColor = .white
        reslut.layer.cornerRadius = 8
        reslut.layer.masksToBounds = true
        return reslut
    }()
    private lazy var todayReadingLabel: UILabel = {
        let result = UILabel(text: "今日跟读", font: UIFont.boldSystemFont(ofSize: 18),alignment: .left)
        result.textColor = UIColor(hexStr: "#353634")
        return result
    }()
    private lazy var historyBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setTitle("历史素材", for: .normal)
        result.setTitleColor(UIColor(hexStr: "#F5B84E"), for: .normal)
        result.titleLabel?.font = .peogooFont(size: .size15)
        result.addTapHandler { [unowned self] in
            print("历史素材")
            self.gotoHistoryHandle?(hModel!.recetingID)
        }
        return result
    }()
    private lazy var topImageV: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFill
        result.layer.masksToBounds = true
        result.layer.cornerRadius = 4
        result.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer { [unowned self] in
            guard let tmpModel = hModel else { return }
            let vc = DGRectingDetailVC(nodeId: tmpModel.recetingID,isFromHotOrNewRecting: false)
            vc.from = .todayRecting
            viewController?.dg_Push(vc, animated: true)
        }
        result.addGestureRecognizer(tap)
        return result
    }()
    private lazy var contentlabel: YYLabel = {
        let result = YYLabel()
        result.textColor = .peogooDarkerGray
        result.font = .peogooFont(size: .size15)
        result.numberOfLines = 2
        result.displaysAsynchronously = true
        return result
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .peogooLighterGray
        _addSubViews()
    }
    
    public func fillData(model: DGRectingHeadModel){
        hModel = model
        topImageV.sd_setImage(with: URL(string: "http://test-k8s-oss.peogoo.com/test-dzq/img/1283278004638871552.jpg"), placeholderImage: UIImage(named: "rectingPlachoder"))
        contentlabel.textLayout = model.textLayout
        contentlabel.size_ = model.textLayout.textBoundingSize
        contentlabel.lineBreakMode = .byTruncatingTail
        contentlabel.snp.updateConstraints { (make) in
            make.height.equalTo(CGFloat((model.textLayout.textBoundingSize.height)))
        }
    }
    
    private func _addSubViews() {
        addSubview(backView)
        backView.addSubview(todayReadingLabel)
        backView.addSubview(historyBtn)
        backView.addSubview(topImageV)
        backView.addSubview(contentlabel)
        
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        todayReadingLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
        historyBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(40)
        }
        topImageV.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.left.equalToSuperview().offset(12)
            $0.top.equalTo(todayReadingLabel.snp.bottom)
            $0.height.equalTo((kSCREEN_width - 56)*179.5/319)
        }
        contentlabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(topImageV.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
