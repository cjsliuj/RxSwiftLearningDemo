//
//  Transforming_Observables.swift
//  RxDemo
//
//  Created by jerry on 2017/11/8.
//  Copyright © 2017年 jerry. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
extension OperatorsListVC{
    /*
        最终序列只会发射被 amb 组合的那些序列中最先发射数据的序列的数据。
     */
    func amb(){
        logFunc(#function)
        //设置序列的订阅逻辑该如何调度
        let seq1 = PublishSubject<String>()
        let seq2 = PublishSubject<String>()
        let seq3 = PublishSubject<String>()
        let ambSeq = seq1.amb(seq2).amb(seq3)
        ambSeq.subscribe{print($0)}.disposed(by: GlobalDisposeBag)
        
        //序列2 先发射，则 ambSeq 只会发射序列2的数据
        seq2.onNext("seq2_first")
        
        seq1.onNext("seq1_a")
        seq1.onNext("seq1_b")
        
        seq2.onNext("seq2_a")
        seq2.onNext("seq2_b")
        
        seq3.onNext("seq3_a")
        seq3.onNext("seq3_b")
    }
    /*
     ifEmpty 用来处理序列未发射数据就终止的场景
     原始序列发射了数据，则 ifEmpty 不会生效。
     原始序列未发射数据：
            原始序列正常终止，最终序列就会发射一个 ifEmpty 预先设置好的数据
            原始序列异常终止，ifEmpty 预先设置的数据不会被发射，同时最终序列异常终止。
     */
    //原始序列发射了数据，ifEmpty不生效场景
    func ifEmpty_emit_item(){
        logFunc(#function)
        let seq1 = PublishSubject<String>()
        seq1.ifEmpty(default: "placeholder")
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        seq1.onNext("item1")
        seq1.onCompleted()
    }
    //原始序列正常终止
    func ifEmpty_source_no_emit_item_but_completed(){
        logFunc(#function)
        let seq1 = PublishSubject<String>()
        seq1.ifEmpty(default: "placeholder")
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        seq1.onCompleted()
    }
    //原始序列异常终止
    func ifEmpty_source_no_emit_item_but_error(){
        logFunc(#function)
        let seq1 = PublishSubject<String>()
        seq1.ifEmpty(default: "placeholder")
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        seq1.onError(ExampleError)
    }
    //如果原始序列未发射数据就终止，那么观察者就切换订阅至指定的序列上
    func ifEmptySwitchTo(){
        logFunc(#function)
        let sourceSeq = PublishSubject<String>()
        let standbySeq = PublishSubject<String>()
        
        sourceSeq.ifEmpty(switchTo: standbySeq).subscribe{print($0)}.disposed(by: GlobalDisposeBag)
        
        sourceSeq.onCompleted()
        standbySeq.onNext("备用队列 item1")
        standbySeq.onCompleted()
    }
}

