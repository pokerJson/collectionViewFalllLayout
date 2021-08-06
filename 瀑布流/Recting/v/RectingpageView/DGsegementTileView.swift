//
//  DGsegementTileView.swift
//  很划算的看法哈克水电费
//
//  Created by dzc on 2021/6/8.
//

import UIKit

protocol DGsegementTileViewDelegate : AnyObject {
    func pageView(pageView:DGsegementTileView,selectIndex:Int)
}


class DGsegementTileView: UIView {
    
    weak var delegate:DGsegementTileViewDelegate?
        
    var titles = [String]()
    var titleLabels = [UILabel]()
    
    lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: (UIScreen.main.bounds.width - 270) / 2, y: 0, width: 270, height: 28))
        scroll.layer.cornerRadius = 4
        scroll.layer.masksToBounds = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = .peogooLighterGray
        scroll.layer.borderColor = UIColor(hexStr: "#9B9C9A")?.cgColor
        scroll.layer.borderWidth = 0.5
        return scroll
    }()
    
    lazy var lineView:UIView = {
        let line = UIView()
        line.backgroundColor = .peogooGreenLight
        line.frame.size.height = 28
        line.layer.cornerRadius = 4
        line.layer.masksToBounds = true
        line.frame.origin.y = 0
        return line
    }()
   
    fileprivate var currentIndex:Int = 0
    
    init(frame: CGRect, titles: [String]) {
        
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DGsegementTileView{
    
    fileprivate func setupUI(){
        
        //设置scrollView
        addSubview(scrollView)
        //初始化lineView
        scrollView.addSubview(lineView)
        //初始化title
        setupLabels()
    }
    
    // MARK: 初始化Item
    fileprivate func setupLabels(){
        var x:CGFloat = 0
        let y:CGFloat = 0
        var textWidth:CGFloat = 0
        var labelWidth:CGFloat = 0
        let height:CGFloat = 28
        let margin:CGFloat = 0
        //        let normalWidth:CGFloat = 60
        var preLabel:UILabel = UILabel()
        for (i,title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .gray
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.isUserInteractionEnabled = true
            titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemClick(_:))))
            //设置frame
            textWidth = widthForContent(titleLabel, 0)
            
            labelWidth = 135

            if i == 0{
                x = (scrollView.bounds.size.width - labelWidth*CGFloat(titles.count) - margin*CGFloat(titles.count - 1))/CGFloat(2)
                lineView.frame.origin.x = x
                lineView.frame.size.width = 135
                titleLabel.textColor = .white
                                
            }else{
                
                x = preLabel.frame.maxX + margin
            }
            titleLabel.frame = CGRect(x: x, y: y, width: labelWidth, height: height)
            
            //添加到视图中
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            preLabel = titleLabel
        }
        
        //设置scrollView的ContentSize
        scrollView.contentSize = CGSize(width: 270, height: 0)
    }
    
    fileprivate func widthForContent(_ label:UILabel, _ fontSize: CGFloat = 0) -> CGFloat{
        return ((label.text! as NSString).boundingRect(with: CGSize(width : CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: fontSize > 0 ? UIFont.systemFont(ofSize: fontSize) : label.font], context: nil)).width
    }
}

extension DGsegementTileView{
    
    private func ajustViewPostion(_ selectLabel:UILabel){
        let preLabel = titleLabels[currentIndex]
        currentIndex = selectLabel.tag
        
        preLabel.textColor = .gray
        selectLabel.textColor = .white
        
        //设置lineView的位置
        //计算textWidth
        UIView .animate(withDuration: 0.25) {
            
            self.lineView.frame.origin.x = selectLabel.frame.origin.x
            self.lineView.frame.size.width = 135
        }
        
    }
    
    @objc fileprivate func itemClick(_ tap:UITapGestureRecognizer){
        //获取目标item
        let selectLabel = tap.view as! UILabel
        //调整位置
        ajustViewPostion(selectLabel)
        //通知外部选中状态
        delegate?.pageView(pageView: self, selectIndex: currentIndex)
    }
    
    // MARK: 更新label 更新lineView
    func pageViewScroll(direction: DGMoveDirection,sourceIndex: Int,nextIndex:Int,progress:CGFloat){
        
        let currentLabel = titleLabels[sourceIndex]
        let nextLabel = titleLabels[nextIndex]
        
        
        //设置lineView的渐变
        var deltaX:CGFloat = 0
        var deltaW:CGFloat = 0
        
        
        
        deltaX = nextLabel.center.x - currentLabel.center.x
        lineView.center.x = currentLabel.center.x + deltaX*progress
        deltaW = nextLabel.bounds.width - currentLabel.bounds.width
        lineView.frame.size.width = 135
        
    
    
    }
    
    /// 滚动结束 重试字体颜色 防止字体颜色出现异常
    func reloadColor(){
        let currentLabel = titleLabels[currentIndex]
        //未选中的使用默认颜色
        for lb in titleLabels {
            lb.textColor = .gray
        }
        currentLabel.textColor = .white;
    }
    
    func pageViewScrollEnd(pageIndex:Int){
        
        //拿到选中的label
        let selectLabel = titleLabels[pageIndex]
        ajustViewPostion(selectLabel)
        reloadColor()
    }
    
    private func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard  let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB方式设置")
        }
        
        return (components[0], components[1], components[2])
    }
}
