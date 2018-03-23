//
//  BasicTbvVC.swift
//  RxDemo
//
//  Created by jerry on 2017/11/6.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
typealias Section = DemoModel.Section
typealias Row = DemoModel.Row
typealias RowSubAction = DemoModel.RowSubAction
class BasicTbvVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var _tbv: UITableView!
    var _ds: [Section] = []
    override func viewDidLoad() {
        _tbv = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        _tbv.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        _tbv.delegate = self
        _tbv.dataSource = self
        self.view.addSubview(_tbv)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return _ds.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _ds[section].title
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _ds[section].rows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.setUp(with: _ds[indexPath.section].rows[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewCell.height(for: _ds[indexPath.section].rows[indexPath.row])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ds[indexPath.section].rows[indexPath.row].action()
    }
}

