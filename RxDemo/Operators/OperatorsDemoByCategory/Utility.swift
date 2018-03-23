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
 用于序列的一些工具方法
 */
extension OperatorsListVC{
    //序列如果没有在指定时间内发射数据，则会异常终止。
    //每发射一个数据都会重新计时。
    func timeout(){
        logFunc(#function)
        Observable<Int>.create { (observer) -> Disposable in
            delay(1, {
                observer.onNext(1)
            })
            delay(4, {
                observer.onNext(1)
            })
            return Disposables.create()
        }.timeout(2, scheduler: MainScheduler.instance)
        .subscribe({print($0)})
        .disposed(by: GlobalDisposeBag)
    }
    /*
      最终序列在 N 秒后开始发射原始序列数据
      N秒前的数据并不会丢弃，相当于是将整个原始序列后移 N 秒。
     */
    func delay_operator(){
        logFunc(#function)
        Observable<Int>.create { (observer) -> Disposable in
            var i = 0
            print("create")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if i <= 5{
                    print("原始序列发射数据:\(i) [第 \(i) 秒]")
                    observer.onNext(i)
                }else{
                    print("原始序列正常终止")
                    observer.onCompleted()
                    timer.invalidate()
                }
                i = i+1
            }).fire()
            return Disposables.create()
        }.delay(2, scheduler: MainScheduler.instance)
            .subscribe({print("观察者接收:",$0)})
            .disposed(by: GlobalDisposeBag)
    }
    /*
        delaySubscription 操作符返回一个序列，观察者订阅该序列时，原始序列的被订阅逻辑(subscription)会在 N 秒后被执行。
     */
    func delaySubscription(){
        logFunc(#function)
        let seq = Observable<Int>.create { (observer) -> Disposable in
            print("create 执行了")
            observer.onNext(1)
            observer.onCompleted()
            return Disposables.create()
            }
            .delaySubscription(2, scheduler: MainScheduler.instance)
        print("订阅序列")
        seq.subscribe({print($0)})
            .disposed(by: GlobalDisposeBag)
    }
    //监控序列的生命周期
    func `do`(){
        logFunc(#function)
        let ob = Observable<Int>.of(12,3,4).do(onNext: { (ele) in
            print("onNext")
        }, onError: { (error) in
            print("onError")
        }, onCompleted: {
            print("onCompleted")
        }, onSubscribe: {
            print("onSubscribe")
        }, onSubscribed: {
            print("onSubscribed")
        }) {
            print("on dispose")
        }
        ob.subscribe({print($0)}).disposed(by: GlobalDisposeBag)
    }
    //将原始序列发射的元素包装成 Event<T>的形式，然后在最终序列上发射出去。
    func materialize(){
        logFunc(#function)
        Observable<Int>.of(1,2,3,4)
            .materialize()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
    }
    //原始序列的 error 事件也会被包装
    func materialize_withError(){
        logFunc(#function)
        Observable<Int>.create({ (observer) -> Disposable in
            observer.onNext(1)
            observer.onError(ExampleError)
            return Disposables.create()
        })
            .materialize()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
    }
    /*
        observeOn 用于设置如何调度订阅者逻辑
     */
    //在并发队列上调度
    //该例中，观察者1的逻辑不会阻塞 观察者2 逻辑的执行
    func observeOn_concurrent(){
        logFunc(#function)
        let ob = Observable<Int>.of(1,2).observeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
        ob.subscribe { (event) in
            print("观察者1",event)
            sleep(1)
        }.disposed(by: GlobalDisposeBag)
        ob.subscribe { (event) in
            print("观察者2",event)
        }.disposed(by: GlobalDisposeBag)
    }
    //在串行队列上调度
    //该例中，观察者1的逻辑会阻塞 观察者2 逻辑的执行
    func observeOn_serial(){
        logFunc(#function)
        let ob = Observable<Int>.of(1,2).observeOn(MainScheduler.instance)
        ob.subscribe { (event) in
            print("观察者1",event)
            sleep(1)
        }.disposed(by: GlobalDisposeBag)
        ob.subscribe { (event) in
            print("观察者2",event)
        }.disposed(by: GlobalDisposeBag)
    }
    //设置被订阅逻辑该如何调度
    //该例子中，被订阅逻辑在并发队列调度
    //两个观察者订阅时，序列的被订阅逻辑是并行执行的
    func subscribeOn_concurrent(){
        logFunc(#function)
        let seq = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            observer.onCompleted()
            Thread.sleep(forTimeInterval: 2)
            return Disposables.create()
        }
        seq.subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .subscribe{print("观察者1",$0)}
            .disposed(by: GlobalDisposeBag)
        seq.subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .subscribe{print("观察者2",$0)}
            .disposed(by: GlobalDisposeBag)
        
    }
    //该例子中，被订阅逻辑在串行队列调度
    //两个观察者订阅时，序列的被订阅逻辑是串行执行的
    func subscribeOn_serial(){
        logFunc(#function)
        let seq = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            observer.onCompleted()
            Thread.sleep(forTimeInterval: 2)
            return Disposables.create()
        }
        seq.subscribeOn(MainScheduler.instance)
            .subscribe{print("观察者1",$0)}
            .disposed(by: GlobalDisposeBag)
        seq.subscribeOn(MainScheduler.instance)
            .subscribe{print("观察者2",$0)}
            .disposed(by: GlobalDisposeBag)
    }
}





