//
//  File.swift
//  RxDemo
//
//  Created by jerry on 2017/11/8.
//  Copyright © 2017年 jerry. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
/*
 这些操作符用于创建序列
 */
extension OperatorsListVC{
    //创建既不发射数据也不会终止的序列
    func never(){
        logFunc(#function)
        Observable<String>.never()
            .subscribe{
                print($0)
            }.disposed(by: GlobalDisposeBag)
    }
    //创建不发射数据但会正常终止的序列
    func empty(){
        logFunc(#function)
        Observable<String>.empty()
            .subscribe{
                print($0)
            }.disposed(by: GlobalDisposeBag)
    }
    //创建不发射数据但异常终止的序列
    func error(){
        logFunc(#function)
        Observable<String>.error(ExampleError)
            .subscribe{
                print($0)
            }.disposed(by: GlobalDisposeBag)
    }
    //创建只发射一个数据的序列,然后序列正常终止
    func just(){
        logFunc(#function)
        Observable<String>.just("onlyMe")
            .subscribe{
                print($0)
            }.disposed(by: GlobalDisposeBag)
    }
    //创建发射若干数据的序列,然后序列正常终止
    func of(){
        logFunc(#function)
        Observable<String>.of("a","b","c")
            .subscribe{
                print($0)
            }.disposed(by: GlobalDisposeBag)
    }
    /*
     将其他'集合类型'转换为序列，序列不会终止。
     */
    func from(){
        logFunc(#function)
        Observable<String>.from(["1", "2", "3", "4"])
            .subscribe(onNext: { print($0) })
            .disposed(by: GlobalDisposeBag)
    }
    /*
     自定义序列。
     发射逻辑：每隔一秒按顺序发射指定数组中的一个元素，直至数组中所有元素全部被发射，然后终止序列。
     */
    func create(){
        logFunc(#function)
        let arr = [1,2,3,4]
        Observable<Int>.create { observer in
            var index = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if index >= arr.count{
                    observer.onCompleted()
                    timer.invalidate()
                }else{
                    observer.onNext(arr[index])
                }
                index = index + 1
            })
            return Disposables.create()
            }
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    /*
     创建一个发射指定范围整数的序列。
     注：这里的 Observable 必须是 Observable<Int>, 因为该操作符是用于整型数的
     */
    func range(){
        logFunc(#function)
        Observable<Int>.range(start: 1, count: 5)
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //创建重复发射指定数据的序列，该序列不会终止
    //注：这里将操作放到了分线程，以不至于阻塞主线程
    func `repeat`(){
        logFunc(#function)
        Observable.repeatElement("a", scheduler: ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    /*
     创建一个序列，该序列会根据初始值和迭代逻辑产生数据并发射，当数据满足条件时则会发射数据，如果不满足，则序列中止。迭代结果会作为下一次迭代的输入
     */
    func generate(){
        logFunc(#function)
        Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 }
            )
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    /*
     延迟创建序列操作符。
     该操作符会接收一个序列工厂函数，当订阅发生时，该序列才会被真正的创建，并且其会为每个订阅创建序列。
     
     这里需要注意 defer 延迟的是 Observable.create （创建序列）这个动作，而不是 Observable.create 这个方法传入的闭包的执行时机，Observable.create 传入的闭包参数是一个subscription，其默认就是在订阅时执行的。
     */
    func `defer`(){
        logFunc(#function)
        var seqFlag = 0
        let deferredSequence = Observable<String>.deferred {
            seqFlag += 1
            print("创建序列 seqFlag:\(seqFlag)")
            return Observable.create { observer in
                observer.onNext(String(seqFlag) + "a")
                observer.onNext(String(seqFlag) + "b")
                observer.onCompleted()
                return Disposables.create()
            }
        }
        print("订阅1")
        deferredSequence
            .subscribe {print($0)}
            .disposed(by: GlobalDisposeBag)
        
        print("订阅2")
        deferredSequence
            .subscribe {print($0)}
            .disposed(by: GlobalDisposeBag)
    }
    //创建根据指定间隔时间无限发射递增整数数据的序列。
    func interval(){
        logFunc(#function)
        Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
    }
    //创建一个序列，它会在指定延迟后根据指定的时间间隔无限发射递增整数数据。
    func timer(){
        logFunc(#function)
        let seq = Observable<Int>.timer(2, period: 1,scheduler: MainScheduler.asyncInstance)
        print("订阅 time:",Date())
        seq.subscribe{print("收到事件:",$0,"time:",Date())}
            .disposed(by: GlobalDisposeBag)
    }
}






