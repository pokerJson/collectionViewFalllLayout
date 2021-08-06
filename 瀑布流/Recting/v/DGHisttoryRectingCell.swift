// Copyright © 2021 Peogoo. All rights reserved.

import UIKit

class DGHisttoryRectingCell: UICollectionViewCell {
    
    private let imageVWidth = (UIScreen.main.bounds.width - 32)
    private let imageVHeight = (UIScreen.main.bounds.width - 32) * 193 / 343
    private let contentMargin = 12
    private let contentTopMargin = 8
    private let timeLabelTopMargin = 8
    
    private lazy var imageV: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFill
        result.layer.masksToBounds = true
        return result
    }()
    private lazy var contentlabel: YYLabel = {
        let result = YYLabel()
        result.textColor = .peogooDarkerGray
        result.font = .peogooFont(size: .size14)
        result.numberOfLines = 2
        result.displaysAsynchronously = true
        return result
    }()
    private lazy var timeLabel: UILabel = {
        let result = UILabel(text: "2021-11-12 11:11", font: .peogooFont(size: .size13),alignment: .left)
        result.textColor = UIColor(hexStr: "#9B9C9A")
        return result
    }()
    private lazy var smallDot: UILabel = {
        let result = UILabel()
        result.layer.cornerRadius = 1
        result.layer.masksToBounds = true
        result.backgroundColor = UIColor(hexStr: "#9B9C9A")
        return result
    }()
    private lazy var hasReadNumLabel: UILabel = {
        let result = UILabel(text: "多少人阅读", font: .peogooFont(size: .size13),alignment: .left)
        result.textColor = UIColor(hexStr: "#9B9C9A")
        return result
    }()
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageV)
        contentView.addSubview(contentlabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(smallDot)
        contentView.addSubview(hasReadNumLabel)

       

        imageV.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(imageVHeight)
        }
        contentlabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(contentMargin)
            $0.right.equalToSuperview().offset(-contentMargin)
            $0.top.equalTo(imageV.snp.bottom).offset(contentTopMargin)
            $0.height.equalTo(30)
        }
        timeLabel.snp.makeConstraints {
            $0.left.equalTo(contentlabel)
            $0.top.equalTo(contentlabel.snp.bottom).offset(timeLabelTopMargin)
            $0.height.equalTo(20)
        }
        smallDot.snp.makeConstraints {
            $0.left.equalTo(timeLabel.snp.right).offset(10)
            $0.centerY.equalTo(timeLabel)
            $0.size.equalTo(CGSize(width: 2, height: 2))
        }
        hasReadNumLabel.snp.makeConstraints {
            $0.left.equalTo(smallDot.snp.right).offset(10)
            $0.centerY.equalTo(timeLabel)
            $0.height.equalTo(20)
        }
    }
    
    func fillData(model: DGHostoryRectingModel){
        imageV.sd_setImage(with: URL(string: model.coverImageUrl), placeholderImage: UIImage(named: "rectingPlachoder"))
        contentlabel.textLayout = model.textLayout
        contentlabel.size_ = model.textLayout.textBoundingSize
        contentlabel.lineBreakMode = .byTruncatingTail
        contentlabel.snp.updateConstraints { (make) in
            make.height.equalTo(CGFloat((model.textLayout.textBoundingSize.height)))
        }
//        timeLabel.text = String.timesSwitchTime(timestamp: model.uploadTime , format: "YYYY-MM-dd HH:mm")
        timeLabel.text = model.putawayTime
        hasReadNumLabel.text =  model.followCount + "人已跟读"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
