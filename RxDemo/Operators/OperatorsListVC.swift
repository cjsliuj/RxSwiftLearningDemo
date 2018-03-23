//
//  ViewController.swift
//  RxDemo
//
//  Created by 刘杰 on 2017/11/3.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OperatorsListVC: BasicTbvVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "清理Bag", style: .plain, target: self, action: #selector(onClearBag))
        super._ds  = [
            Section(
                title: "Creating Observables",
                rows: [
                    Row(
                        title: "never",
                        action: never
                    ),
                    Row(
                        title: "empty",
                        action: empty
                    ),
                    Row(
                        title: "error",
                        action: error
                    ),
                    Row(
                        title: "just",
                        action: just
                    ),
                    Row(
                        title: "of",
                        action: of
                    ),
                    Row(
                        title: "from",
                        action: from
                    ),
                    Row(
                        title: "create",
                        action: create
                    ),
                    Row(
                        title: "range",
                        action: range
                    ),
                    Row(
                        title: "repeat",
                        action: `repeat`
                    ),
                    Row(
                        title: "generate",
                        action: generate
                    ),
                    Row(
                        title: "defer",
                        action: `defer`
                    ),
                    Row(
                        title: "interval",
                        action: interval
                    ),
                    Row(
                        title: "timer",
                        action: timer
                    )
                ]
            ),
            Section(
                title: "Combining Observables",
                rows: [
                    Row(
                        title: "startWith",
                        action: startWith
                    ),
                    Row(
                        title: "merge",
                        action: merge,
                        subActions:[
                            RowSubAction(
                                title: "合并的序列中有序列异常终止",
                                action: mergeWithError
                            ),
                            RowSubAction(
                                title: "合并的序列中有序列正常终止",
                                action:mergeWithCompleted
                            )
                        ]
                    ),
                    Row(
                        title: "zip",
                        action: zip,
                        subActions:[
                            RowSubAction(
                                title: "压缩的序列中有正常终止",
                                action: zipWithCompleted
                            ),
                            RowSubAction(
                                title: "压缩的序列中有异常终止",
                                action: zipWithError
                            )
                        ]
                    ),
                    Row(
                        title: "combineLatest",
                        action: combineLatest
                    ),
                    Row(
                        title: "switchLatest",
                        action: switchLatest,
                        subActions:[
                            RowSubAction(
                                title: "仅原始序列终止",
                                action: switchLatest_only_sourceSeq_completed
                            ),
                            RowSubAction(
                                title: "原始序列 和 当前订阅序列都终止",
                                action: switchLatest_completed_all
                            ),
                            RowSubAction(
                                title: "原始序列 或 当前订阅序列异常终止",
                                action: switchLatest_error
                            )
                        ]
                    )
                ]
            ),
            Section(
                title: "Transforming Observables",
                rows: [
                    Row(
                        title: "map",
                        action: `map`
                    ),
                    Row(
                        title: "flatMap\t>",
                        action: flatMap
                    ),
                    Row(
                        title: "flatMapLatest\t>",
                        action: flatMapLatest
                    ),
                    Row(
                        title: "scan",
                        action: scan
                    ),
                    Row(
                        title: "buffer",
                        action: buffer,
                        subActions:[
                            RowSubAction(
                                title: "原始序列异常终止",
                                action: buffer_error
                            ),
                            RowSubAction(
                                title: "原始序列正常终止",
                                action: buffer_complete
                            )
                        ]
                    ),
                    Row(
                        title: "window",
                        action: window
                    ),
                    Row(
                        title: "groupBy",
                        action: groupBy
                    )
                ]
            ),
            Section(
                title: "Filtering",
                rows: [
                    Row(
                        title: "filter",
                        action: filter
                    ),
                    Row(
                        title: "ignoreElements",
                        action: ignoreElements
                    ),
                    Row(
                        title: "distinctUntilChanged",
                        action: distinctUntilChanged
                    ),
                    Row(
                        title: "elementAt",
                        action: elementAt
                    ),
                    Row(
                        title: "take",
                        action: take
                    ),
                    Row(
                        title: "takeLast",
                        action: takeLast
                    ),
                    Row(
                        title: "takeWhile",
                        action: takeWhile
                    ),
                    Row(
                        title: "takeUntil",
                        action: takeUntil,
                        subActions:[
                            RowSubAction(
                                title: "参照序列异常终止",
                                action: takeUntilWithRefSeqError
                            ),
                            RowSubAction(
                                title: "参照序列正常终止",
                                action: takeUntilWithRefSeqComplete
                            )
                        ]
                    ),
                    Row(
                        title: "skip",
                        action: skip
                    ),
                    Row(
                        title: "skipDuration",
                        action: skipDuration
                    ),
                    Row(
                        title: "skipWhile",
                        action: skipWhile
                    ),
                    Row(
                        title: "skipUntil",
                        action: skipUntil,
                        subActions:[
                            RowSubAction(
                                title: "参照序列异常终止",
                                action: skipUntilWithRefSeqError
                            ),
                            RowSubAction(
                                title: "参照序列正常终止",
                                action: skipUntilWithRefSeqComplete
                            )
                        ]
                    ),
                    Row(
                        title: "sample",
                        action: sample
                    ),
                    Row(
                        title: "throttle",
                        action: {},
                        subActions:[
                            RowSubAction(
                                title: "throttle_withLastParamFalse",
                                action: throttle_withLastParamFalse
                            ),
                            RowSubAction(
                                title: "throttle_withLastParamTrue",
                                action: throttle_withLastParamTrue
                            )
                        ]
                    ),
                    Row(
                        title: "debounce",
                        action: debounce
                    ),
                ]
            ),
            Section(
                title: "Mathematical and Aggregate",
                rows: [
                    Row(
                        title: "reduce",
                        action: reduce
                    ),
                    Row(
                        title: "concat",
                        action: concat,
                        subActions:[
                            RowSubAction(
                                title: "合并的序列中有序列异常终止",
                                action: concat_error
                            )
                        ]
                    )
                ]
            ),
            Section(
                title: "Connectable",
                rows: [
                    Row(
                        title: "publish",
                        action: publish
                    ),
                    Row(
                        title: "connect",
                        action: connect,
                        subActions:[
                            RowSubAction(
                                title: "非 Connectable序列 对比",
                                action: without_connect
                            )
                        ]
                    ),
                    Row(
                        title: "replay",
                        action: replay
                    ),
                    Row(
                        title: "replayAll",
                        action: replayAll
                    ),
                    Row(
                        title: "multicast",
                        action: multicast
                    )
                    
                ]
            ),
            Section(
                title: "Error Handling Operators",
                rows: [
                    Row(
                        title: "catchErrorJustReturn",
                        action: catchErrorJustReturn
                    ),
                    Row(
                        title: "catchError",
                        action: catchError
                    ),Row(
                        title: "retry",
                        action: retry
                    ),Row(
                        title: "retryMaxAttemptCount",
                        action: retryMaxAttemptCount
                    ),Row(
                        title: "retryWhen",
                        action: retryWhen
                    )
                ]
            ),
            Section(
                title: "Conditional and Boolean",
                rows: [
                    Row(
                        title: "amb",
                        action: amb
                    ),
                    Row(
                        title: "ifEmpty",
                        subActions:[
                            RowSubAction(
                                title: "原始序列发射了数据",
                                action: ifEmpty_emit_item
                            ),
                            RowSubAction(
                                title: "原始序列未发射数据并正常终止",
                                action: ifEmpty_source_no_emit_item_but_completed
                            ),
                            RowSubAction(
                                title: "原始序列未发射数据并异常终止",
                                action: ifEmpty_source_no_emit_item_but_error
                            )
                        ]
                    ),
                    Row(
                        title: "ifEmptySwitchTo",
                        action: ifEmptySwitchTo
                    )
                ]
            ),
            Section(
                title: "Convert_Observables",
                rows: [
                    Row(
                        title: "toArray",
                        action: toArray
                    )
                ]
            ),
            Section(
                title: "Utility",
                rows: [
                    Row(
                        title: "timeout",
                        action: timeout
                    ),
                    Row(
                        title: "delay",
                        action: delay_operator
                    ),
                    Row(
                        title: "delaySubscription",
                        action: delaySubscription
                    ),
                    Row(
                        title: "do",
                        action: `do`
                    ),
                    Row(
                        title: "materialize",
                        action: materialize,
                        subActions:[
                            RowSubAction(
                                title: "原始序列异常终止场景",
                                action: materialize_withError
                            )
                        ]
                    ),
                    
                    Row(
                        title: "observeOn",
                        subActions:[
                            RowSubAction(
                                title: "并发队列场景",
                                action: observeOn_concurrent
                            ),
                            RowSubAction(
                                title: "串行队列场景",
                                action: observeOn_serial
                            )
                        ]
                    ),
                    Row(
                        title: "subscribeOn",
                        subActions:[
                            RowSubAction(
                                title: "并发队列场景",
                                action: subscribeOn_concurrent
                            ),
                            RowSubAction(
                                title: "串行队列场景",
                                action: subscribeOn_serial
                            )
                        ]
                    )
                ]
            )
        ]
        
        let operatorsCount = _ds.map { (section) -> Int in
            return section.rows.count
            }.reduce(0) { (aggre, ele) -> Int in
                return aggre + ele
        }
        self.title = "Operators(\(operatorsCount))"
        
        
        
        
        
        
    }
    @objc func onClearBag(){
        clearGlobalDisposeBag()
    }
    override func viewWillDisappear(_ animated: Bool) {
        clearGlobalDisposeBag()
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let s = NSStringFromSelector(#selector(getter: super._ds[indexPath.section].rows[indexPath.row].action))
//        print(s)
//        super.tableView(tableView, didSelectRowAt: indexPath)
//    }
    
}

