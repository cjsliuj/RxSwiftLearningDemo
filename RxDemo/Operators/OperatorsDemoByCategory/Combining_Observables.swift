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
/*
 这些操作符主要用于将多个序列组合成一个序列
 */
extension OperatorsListVC{
    /*
     最终序列会在发射原始序列数据前，先发射 startWith 操作符插入的数据。
     注：startWith 插入的数据是'先进后出'的
     */
    func startWith(){
        logFunc(#function)
        let ob = Observable.of("a", "b", "c", "d")
            .startWith("1")
            .startWith("2")
            .startWith("3", "4", "5")
        
        ob.subscribe(onNext: { print($0) })
            .disposed(by: GlobalDisposeBag)
    }
    /*
     合并多个序列，当被合并的序列中有任何一个序列发射数据时，该数据则会通过'最终序列'发射出去。
     最终序列发射数据是没有顺序的，被合并的序列只要发射数据，最终序列就会立即将其发射出去。
     */
    func merge(){
        logFunc(#function)
        
        let disposeBag = DisposeBag()
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        Observable<String>.merge([subject1,subject2])
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        subject2.onNext("①")
        subject2.onNext("②")
        subject1.onNext("🆎")
        subject2.onNext("③")
        
    }
    
    /*
     只要有一个序列异常终止，则最终序列就会异常终止
     */
    func mergeWithError(){
        logFunc(#function)
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        Observable.of(subject1, subject2)
            .merge()
            .subscribe {print($0)}
            .disposed(by: GlobalDisposeBag)
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        
        subject2.onNext("①")
        subject2.onNext("②")
        
        subject1.onError(ExampleError)
        
        subject2.onNext("③")
    }
    /*
     注：必须所有序列都正常终止，最终序列才会正常终止。
     */
    func mergeWithCompleted(){
        logFunc(#function)
 
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        Observable.of(subject1, subject2)
            .merge()
            .subscribe {print($0)}
            .disposed(by: GlobalDisposeBag)
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        
        subject2.onNext("①")
        subject2.onNext("②")
        
        subject1.onCompleted()
        
        subject2.onNext("③")
        
        subject2.onCompleted()
        
    }
    /*
     当被'压缩'的任何一个序列发射数据时，zip 会寻找所有其他序列发射过的数据中'发射序号'(这个数据在序列中是第几个发射的)与当前发射数据的'发射序号'相同的数据，
     然后将这些元素'压缩'为一个数据在'最终序列'中发射出去。
     
     特别需要注意的是'发射序号'相同这个条件，比如有A、B、C三个序列，
     当A发射了第一个数据，B也发射了第一个数据，C没有发射，'最终序列'不会发射数据，
     之后，当C发射了第一个数据，此时就会将A、B、C序列中的第一个数据'压缩'，然后在'最终序列'中发射。
     （此处用 http://reactivex.io/documentation/operators/zip.html 中的弹珠图演示比较好）
     
     zip 接受一个用与处理'压缩'的函数
     
     RxSwift 的实现中，zip最多可以合并8个序列
     */
    func zip(){
        logFunc(#function)
   
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
        
        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")
        
        intSubject.onNext(1)
        
        intSubject.onNext(2)
        
        stringSubject.onNext("🆎")
        intSubject.onNext(3)
    }
    /*
     压缩的序列中即使某个序列正常终止了，如果其他序列还在发射元素，并且能够匹配到其他已终止序列中相同'发射序号'的元素，那么就仍然可以执行zip操作。
     */
    func zipWithCompleted(){
        logFunc(#function)
 
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
        
        stringSubject.onNext("a")
        stringSubject.onNext("b")
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        stringSubject.onNext("c")
        stringSubject.onNext("d")
        stringSubject.onCompleted()
        intSubject.onNext(3)
        intSubject.onCompleted()
        
    }
    /*
     压缩的序列中只要有一个序列异常终止，那么'最终序列'就会异常终止。
     */
    func zipWithError(){
        logFunc(#function)
 
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
        
        stringSubject.onNext("a")
        stringSubject.onNext("b")
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        stringSubject.onNext("c")
        stringSubject.onNext("d")
        stringSubject.onError(ExampleError)
        intSubject.onNext(3)
        intSubject.onCompleted()
    }
    /*
     与zip有点类似，不同的是，当被 combine 的任何一个序列发射数据时，combineLatest 会把所有序列中的最近一次发射的数据'合并'为一个数据，然后在'最终序列'中发射出去。
     其正常终止 和 异常终止的行为与 zip 一样。
     http://reactivex.io/documentation/operators/combinelatest.html
     */
    func combineLatest(){
        logFunc(#function)
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: GlobalDisposeBag)
        
        stringSubject.onNext("🅰️")
        
        stringSubject.onNext("🅱️")
        intSubject.onNext(1)
        
        intSubject.onNext(2)
        
        stringSubject.onNext("🆎")
    }
    /*
     当订阅一个发射序列的序列时，使用 switchLatest 会切换订阅目标至最近被发射的序列。
     */
    func switchLatest(){
        logFunc(#function)
 
        let subSeq1 = PublishSubject<String>.init()
        let subSeq2 = PublishSubject<String>.init()
        let  sourceSeq = PublishSubject<PublishSubject<String>>.init()
        
        sourceSeq.switchLatest()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        
        sourceSeq.onNext(subSeq1)
        subSeq1.onNext("1a")
        subSeq1.onNext("1b")
        
        sourceSeq.onNext(subSeq2)
        subSeq1.onNext("1c") //这个1c不会输出 因为订阅会切换到最新的序列上 （subSeq2）
        
        subSeq2.onNext("2a")
        subSeq2.onNext("2b")
        
        sourceSeq.onNext(subSeq1)
        subSeq1.onNext("1d") //此时会输出 1d 因为subSeq1被发射，订阅切换到 subSeq1 上
        
    }
    /*
     只要原始序列正常终止，其他序列不终止， 最终序列并不会终止。
     */
    func switchLatest_only_sourceSeq_completed(){
        logFunc(#function)
        let subSeq1 = PublishSubject<String>.init()
        let subSeq2 = PublishSubject<String>.init()
        let sourceSeq = PublishSubject<PublishSubject<String>>.init()
        
        sourceSeq.switchLatest()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        
        sourceSeq.onNext(subSeq1)
        subSeq1.onNext("1a")
        subSeq1.onNext("1b")
        
        sourceSeq.onNext(subSeq2)
        
        subSeq2.onNext("2a")
        subSeq2.onNext("2b")
        sourceSeq.onCompleted()
        subSeq2.onNext("2c") //会输出
        
    }
    /*
     只有当 原始序列 和 当前所订阅的序列都正常终止时，最终序列才会正常终止。
     */
    func switchLatest_completed_all(){
        logFunc(#function)
        let subSeq1 = PublishSubject<String>.init()
        let subSeq2 = PublishSubject<String>.init()
        let sourceSeq = PublishSubject<PublishSubject<String>>.init()
        
        sourceSeq.switchLatest()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        
        sourceSeq.onNext(subSeq1)
        subSeq1.onNext("1a")
        subSeq1.onNext("1b")
        
        sourceSeq.onNext(subSeq2)
        
        subSeq2.onNext("2a")
        subSeq2.onNext("2b")
        sourceSeq.onCompleted()
        subSeq2.onCompleted()
        subSeq2.onNext("2c") //不会输出
        
    }
    
    /*
     当原始序列 或 当前订阅的序列中任何一个异常终止，最终序列会立即异常终止
     */
    func switchLatest_error(){
        logFunc(#function)
        let subSeq1 = PublishSubject<String>.init()
        let subSeq2 = PublishSubject<String>.init()
        let sourceSeq = PublishSubject<PublishSubject<String>>.init()
        
        sourceSeq.switchLatest()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
        
        sourceSeq.onNext(subSeq1)
        subSeq1.onNext("1a")
        subSeq1.onNext("1b")
        
        sourceSeq.onNext(subSeq2)
        
        subSeq2.onNext("2a")
        subSeq2.onNext("2b")
        //subSeq2.onError(ExampleError)//订阅序列异常终止的场景，与 sourceSeq异常终止的效果一样。去除注释运行可以查看效果。
        sourceSeq.onError(ExampleError)
    }
}

