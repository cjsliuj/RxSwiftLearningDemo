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
 变换某个序列发射的数据
 */
extension OperatorsListVC{
    //将原始序列发射的数据进行一次转换，然后在最终序列中发射。
    func `map`(){
        logFunc(#function)
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3)
            .map { String($0)+"a" }
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
    }
    /*
     将原始序列发射的数据变换成序列，最终序列上发射的是这些变换序列发射的数据。
     从降维角度：  原始序列发射的每个数据被映射为一个序列，但是最终序列发射的是映射的那些序列所发射的数据。
     从异步操作的角度：item -> Observalbe<T> 表示一个异步操作的结果，触发了另外一个异步操作。
     */
    func flatMap(){
        logFunc(#function)
        self.navigationController?.pushViewController(FlatMapDemoVC(), animated: true)
    }
    /*
     将原始序列发射的数据变换成序列，最终序列上发射的是最近一次变换产生的序列发射的元素。
     */
    func flatMapLatest(){
        logFunc(#function)
        self.navigationController?.pushViewController(FlatMapLatestDemoVC(), animated: true)
    }
    /*
     该操作符拥有'累积计算'效果。
     原始序列发射数据时，会使用 scan 操作符提供的函数进行计算，返回一个新数据，然后在最终序列上发射出去，每次 scan 计算的结果会参与下一次计算。
     */
    func scan(){
        logFunc(#function)
        Observable.of(10, 100, 1000)
            .scan(1) { aggregateValue, newValue in
                print(aggregateValue, newValue)
                return aggregateValue + newValue
            }
            .subscribe(onNext: { print("观察者接收到:",$0) })
            .disposed(by: GlobalDisposeBag)
    }
    /*
     原始序列发射数据时，最终序列会将数据缓存到一个容量为 N，有效时长为 M 的缓冲区内。当缓冲区被填满或者失效时，缓冲区内的所有数据会被最终序列
     打包进一个数组，然后整个数组做为一条数据被最终序列发射出去。然后刷新缓冲区（清理数据、状态置为有效），如此循环往复。
     
     比如等电梯，装满人或者5秒钟没人进来，就关门。
     */
    func buffer(){
        logFunc(#function)
        let subject = PublishSubject<Int>()
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe({print($0)}).disposed(by: GlobalDisposeBag)
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        //1、2、3会先输出，因为达到了 count 条件
        //4会过一秒输出，因为达到 timeSpan 条件 （1，2，3输出后，缓冲区重置）
    }
    //原始序列异常终止时，缓冲区的数据不会被输出，最终序列直接异常终止。
    func buffer_error(){
        logFunc(#function)
        let subject = PublishSubject<Int>()
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe({print($0)}).disposed(by: GlobalDisposeBag)
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        subject.onError(ExampleError)
        
    }
    //原始序列正常终止时，缓冲区的数据会立即输出，最终然后正常终止。
    func buffer_complete(){
        logFunc(#function)
        let subject = PublishSubject<Int>()
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe({print($0)}).disposed(by: GlobalDisposeBag)
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        subject.onCompleted()
    }
    
    /*
        原始序列发射数据时，最终序列会把数据发送到一个容量为 N，有效时长为 M 的窗口内，同时最终序列会把窗口发射出去，
        观察者会监听窗口，当有数据被发送到窗口，观察者则会接收到数据。如果窗口被填满或窗口失效，则会创建一个新的窗口（窗口创建时就会被发射出去）。
        简单点说，window 返回的序列发射的是一个序列，该序列就是用于获取窗口数据的。
    */
    func window(){
        logFunc(#function)
        let subject = PublishSubject<Int>()
        subject.window(timeSpan: 2, count: 3, scheduler: MainScheduler.asyncInstance)
            .flatMap({ (seq) -> Observable<Int> in
                print("接收到的最终序列的发射的数据（窗口 observable）",seq)
                return seq
            })
            .subscribe({print($0)}).disposed(by: GlobalDisposeBag)
        
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
    }
    /*
     原始序列发射的数据，会根据指定的条件被分配到相应的'分组序列'中，'分组序列'会做为最终序列的数据被发射出去，
     一个'分组序列'只会被发射一次，当有新的分组产生时，最终序列才会发射'分组序列'。观察者可以通过监听不同的分组序列以
     得到对应分组的数据。
     */
    func groupBy(){
        logFunc(#function)
        
        let groupSeq = Observable<Int>.of(-2,-20,0,14,21,34,55,62,73,80,90,92,100,102,150).groupBy { (score) -> String in
            if score < 60 && score >= 0{
                return "不及格"
            }else if score >= 60 && score < 90{
                return "良好"
            }else if score >= 90 && score <= 100{
                return "优秀"
            }else{
                return "invalid"
            }
            }.publish()
        /* 筛选出分组序列 */
        let bujigeSeq = groupSeq.filter({ (item: GroupedObservable<String,Int>) -> Bool in
            if item.key.contains("不及格"){
                return true
            }
            return false
        }).flatMap { (groupedSeq: GroupedObservable<String,Int>) -> Observable<Int> in
            return groupedSeq.asObservable()
            }
        bujigeSeq.subscribe{print("不及格-观察者",$0)}.disposed(by: GlobalDisposeBag)
        
        let lianghaoSeq = groupSeq.filter({ (item: GroupedObservable<String,Int>) -> Bool in
            if item.key.contains("良好"){
                return true
            }
            return false
        }).flatMap { (groupedSeq: GroupedObservable<String,Int>) -> Observable<Int> in
            return groupedSeq.asObservable()
            }
        lianghaoSeq.subscribe{print("良好-观察者",$0)}.disposed(by: GlobalDisposeBag)
        
        let youxiuSeq = groupSeq.filter({ (item: GroupedObservable<String,Int>) -> Bool in
            if item.key.contains("优秀"){
                return true
            }
            return false
        }).flatMap { (groupedSeq: GroupedObservable<String,Int>) -> Observable<Int> in
            return groupedSeq.asObservable()
            }
        youxiuSeq.subscribe{print("优秀-观察者",$0)}.disposed(by: GlobalDisposeBag)
        
        groupSeq.connect().disposed(by: GlobalDisposeBag)
    }
    
}

