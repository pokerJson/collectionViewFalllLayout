// Copyright © 2021 Peogoo. All rights reserved.

import UIKit

class DGCustomRectingCell: UICollectionViewCell {
    
    private let imageVWidth = (UIScreen.main.bounds.width - 45)/2
    private let imageVHeight = (UIScreen.main.bounds.width - 45)/2 * 93 / 165
    private let contentMargin = 8
    private let contentTopMargin = 4
    private let likeUpLabelTopMargin = 6
    private let iconTopMargin = 8
    
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
    private lazy var likeUpNumLabel: UILabel = {
        let result = UILabel(text: "点赞量", font: .peogooFont(size: .size13),alignment: .left)
        result.textColor = UIColor(hexStr: "#9B9C9A")
        return result
    }()
    private lazy var avatarImagev: UIImageView = {
        let result = EPImageView.fillImageV()
        result.layer.cornerRadius = 10
        return result
    }()
    private lazy var studentNameLabel: UILabel = {
        let result = UILabel(text: "学员姓名", font: .peogooFont(size: .size13),alignment: .left)
        result.textColor = UIColor(hexStr: "#5F605E")
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
        contentView.addSubview(likeUpNumLabel)
        contentView.addSubview(avatarImagev)
        contentView.addSubview(studentNameLabel)

       

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
        likeUpNumLabel.snp.makeConstraints {
            $0.left.equalTo(contentlabel)
            $0.right.equalTo(contentlabel)
            $0.top.equalTo(contentlabel.snp.bottom).offset(likeUpLabelTopMargin)
            $0.height.equalTo(20)
        }
        avatarImagev.snp.makeConstraints {
            $0.left.equalTo(contentlabel)
            $0.top.equalTo(likeUpNumLabel.snp.bottom).offset(iconTopMargin)
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        studentNameLabel.snp.makeConstraints {
            $0.left.equalTo(avatarImagev.snp.right).offset(6)
            $0.right.equalTo(contentlabel)
            $0.centerY.equalTo(avatarImagev)
            $0.height.equalTo(20)
        }
    }
    
    func fillData(model: DGHotRectingModel){
        imageV.sd_setImage(with: URL(string: model.coverImageUrl), placeholderImage: UIImage(named: "rectingPlachoder"))
        contentlabel.textLayout = model.textLayout
        contentlabel.size_ = model.textLayout.textBoundingSize
        contentlabel.lineBreakMode = .byTruncatingTail
        contentlabel.snp.updateConstraints { (make) in
            make.height.equalTo(CGFloat((model.textLayout.textBoundingSize.height)))
        }
        likeUpNumLabel.text = "点赞量 \(model.givelikeCount)"
        avatarImagev.sd_setImage(with: URL(string: model.photoUrl), placeholderImage: UIImage(named: "mine_header_account_default_img"))
        studentNameLabel.text =  String.getStringWithPrefix(str: model.announcerNick, num: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
