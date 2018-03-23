//
//  MainVC.swift
//  RxDemo
//
//  Created by jerry on 2017/11/5.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
import Foundation
class MainVC: BasicTbvVC {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "RxSwiftDemo"
        super._ds = [
            Section(
                title: "操作符Demo",
                rows: [
                    Row(
                        title: "Operators",
                        action: {
                            self.navigationController?.pushViewController(OperatorsListVC(), animated: true)
                        }
                    ),
                    Row(
                        title: "Subject",
                        action: {self.navigationController?.pushViewController(SubjectMainVC(), animated: true)}
                    )
                ]
            ),
            Section(
                title: "业务场景Demo",
                rows: [
                    Row(
                        title: "注册",
                        action: {self.navigationController?.pushViewController(SignUpVC(), animated: true)}
                    )
                ]
            )
        ]
    }
}

