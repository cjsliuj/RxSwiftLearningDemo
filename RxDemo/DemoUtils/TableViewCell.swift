//
//  TableViewCell.swift
//  RxDemo
//
//  Created by jerry on 2017/11/11.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    struct Constant{
        static let subActionViewHeight = 40
    }
    
    var _row: Row!
    static let caculateHeightCell: TableViewCell = {
        let v = (Bundle.main.loadNibNamed("TableViewCell", owner: nil, options: nil)?.first as? TableViewCell)!
        return v
    }()
    @IBOutlet var _mainTitleLb: UILabel!
    @IBOutlet weak var _constraint_mainTitleLb_top: NSLayoutConstraint!
    @IBOutlet weak var _constraint_subActionsCtnView_height: NSLayoutConstraint!
    @IBOutlet weak var _constraint_mainTitleLb_bottom: NSLayoutConstraint!
    @IBOutlet var _subActionsCtnView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(with row: Row){
        _row = row
        _mainTitleLb.text = row.title
        if _row.subActions.count > 0{
            addSubActions()
        }else{
            cleanSubActions()
        }
    }
    static func height(for row: Row) -> CGFloat{
        return caculateHeightCell.height(for:row)
    }
    func height(for row: Row) -> CGFloat{
        let h = _constraint_mainTitleLb_top.constant
            + _constraint_mainTitleLb_bottom.constant
            + (row.title as NSString)
                .boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                              options: [],
                              attributes: [NSAttributedStringKey.font:_mainTitleLb.font],
                              context: nil)
                .height
            + CGFloat(row.subActions.count * Constant.subActionViewHeight)
        return h
    }
    private func cleanSubActions(){
        _subActionsCtnView.subviews.forEach { (subv) in
            subv.removeFromSuperview()
        }
        
        _constraint_subActionsCtnView_height.constant = 0
    }
    private func addSubActions(){
        _subActionsCtnView.subviews.forEach { (subv) in
            subv.removeFromSuperview()
        }
        for (index, subAction) in _row.subActions.enumerated(){
            let btn = UIButton.init(type: .custom)
            btn.contentHorizontalAlignment = .left

            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setBackgroundImage(UIImage.init(color: UIColor.white), for: .normal)
            btn.setBackgroundImage(UIImage.init(color: UIColor.init(valueRGB: 0xd3d3d3)), for: .highlighted)
            btn.tag = index
            btn.setTitle(subAction.title, for: .normal)
            btn.addTarget(self, action: #selector(onClickSubActionBtn), for: .touchUpInside)
            _subActionsCtnView.addSubview(btn)
        }
        //布局
        for (index, btn) in _subActionsCtnView.subviews.enumerated(){
            if index == 0{
                btn.snp.makeConstraints({ (maker) in
                    maker.top.equalTo(_subActionsCtnView.snp.top)
                })
            }
            if index >= 1{
                let lastBtn = _subActionsCtnView.subviews[index-1]
                btn.snp.makeConstraints({ (maker) in
                    maker.top.equalTo(lastBtn.snp.bottom)
                })
            }
            btn.snp.makeConstraints({ (maker) in
                maker.leading.equalToSuperview().inset(50)
                maker.trailing.equalToSuperview()
                maker.height.equalTo(Constant.subActionViewHeight)
            })
        }
        _constraint_subActionsCtnView_height.constant = CGFloat(_subActionsCtnView.subviews.count * Constant.subActionViewHeight)
    }
    @objc func onClickSubActionBtn(btn: UIButton){
        _row.subActions[btn.tag].action()
    }
}
