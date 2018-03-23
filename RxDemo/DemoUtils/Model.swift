//
//  Model.swift
//  RxDemo
//
//  Created by jerry on 2017/11/5.
//  Copyright © 2017年 jerry. All rights reserved.
//

import Foundation
import UIKit
extension String: Error{}
class DemoModel{
    
    struct Section {
        let title: String
        let rows: [Row]
    }
    struct RowSubAction{
        let title: String
        let action: ()->Void
    }
    struct Row {
        let subActions: [RowSubAction]
        let title: String
        let action: ()->Void
        let titleColor: UIColor
        init(title: String, action: @escaping ()->Void = {}, titleColor: UIColor = UIColor.black, subActions:[RowSubAction] = []) {
            self.title = title
            self.action = action
            self.titleColor = titleColor
            self.subActions = subActions
        }
        
    }
}

