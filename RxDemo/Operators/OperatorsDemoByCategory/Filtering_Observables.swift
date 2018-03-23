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
//这些操作符用于过滤和选择序列发射的数据
extension OperatorsListVC{
    //过滤掉序列中不满足条件的数据
    func filter(){
        logFunc(#function)
        //过滤奇数
        Observable.of(1,2,3,4,5)
            .filter {
                $0 % 2 == 0
            }
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //忽略所有元素，正常终止。
    func ignoreElements(){
        logFunc(#function)
        Observable<Int>.of(1,2)
            .ignoreElements()
            .subscribe{print($0)}
            .disposed(by: GlobalDisposeBag)
    }
    //过滤掉与上一条数据相同的数据
    func distinctUntilChanged(){
        logFunc(#function)
        //过滤连续相同元素
        Observable.of(1,2,3,3,4,5,5,6,5,6,7)
            .distinctUntilChanged()
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //发射序列中指定位置的数据
    func elementAt(){
        logFunc(#function)
        Observable.of("a","b","c","d")
            .elementAt(2)
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //发射序列中前N条数据
    func take(){
        logFunc(#function)
        Observable.of(1,2,3,5)
            .take(2)
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    /*
     发射序列后N条数据
     由于是倒序指定，所以需要序列正常终止后才会开始发射数据。
     如果序列异常终止，则不会发射任何数据
     */
    func takeLast(){
        logFunc(#function)
        let seq = Observable<Int>.create { (observer) -> Disposable in
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if i <= 4{
                    observer.onNext(i)
                    i = i+1
                }else{
                    observer.onCompleted()
                    timer.invalidate()
                    //如果是 异常终止 ，则不会发射数据
                    //observer.onError("Some error")
                }
            }).fire()
            return Disposables.create()
            }.takeLast(3)
        print("订阅 time: ", Date())
        seq.subscribe{print("收到事件:",$0," time: ",Date())}
            .disposed(by: GlobalDisposeBag)
    }
    //序列一直发射数据直到某条数据不满足指定条件，然后序列正常终止。
    func takeWhile(){
        logFunc(#function)
        Observable.of(1, 2, 3, 4, 5, 6)
            .takeWhile { $0 < 4 }
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //一直发射数据直到参照序列发射数据时，原始序列正常终止。
    func takeUntil(){
        logFunc(#function)
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sourceSequence.onNext("1")
        sourceSequence.onNext("2")
        sourceSequence.onNext("3")
        print("参照序列发射元素")
        referenceSequence.onNext("a")
        
        sourceSequence.onNext("4")
        sourceSequence.onNext("5")
        sourceSequence.onNext("6")
    }
    //参照序列异常终止则最终序列也异常终止
    func takeUntilWithRefSeqError(){
        logFunc(#function)
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sourceSequence.onNext("1")
        sourceSequence.onNext("2")
        sourceSequence.onNext("3")
        print("参照序列异常终止")
        referenceSequence.onError(ExampleError)
        
        sourceSequence.onNext("4")
        sourceSequence.onNext("5")
        sourceSequence.onNext("6")
    }
    //参照序列正常终止,原始序列并不会终止。
    func takeUntilWithRefSeqComplete(){
        logFunc(#function)
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sourceSequence.onNext("1")
        sourceSequence.onNext("2")
        sourceSequence.onNext("3")
        referenceSequence.onNext("a")
        print("参照序列正常终止")
        referenceSequence.onCompleted()
        
        sourceSequence.onNext("4")
        sourceSequence.onNext("5")
        sourceSequence.onNext("6")
    }
    //序列发射时跳过前N条数据
    func skip(){
        logFunc(#function)
        Observable.of(1,2,3,4,5)
            .skip(2)
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //序列在N秒后开始发射数据，
    func skipDuration(){
        logFunc(#function)
        Observable<Int>.create { (observer) -> Disposable in
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                print("原始序列发射数据: ",i,"time: ",Date())
                if i <= 5{
                    observer.onNext(i)
                }else{
                    observer.onCompleted()
                    timer.invalidate()
                }
                i = i+1
            })
            return Disposables.create()
            }
            .skip(2.5, scheduler: MainScheduler.instance)
            .subscribe{print("接收到数据: ",$0," time: ",Date())}
            .disposed(by: GlobalDisposeBag)
    }
    
    //序列会跳过不满条件的数据，然后开始发射，开始发射后则不会跳过不满足条件的数据。
    func skipWhile(){
        logFunc(#function)
        Observable.of(1, 2, 3, 4, 1, 2, 3)
            .skipWhile { $0 < 4 }
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //直到参照序列发射数据，最终序列才开始发射
    func skipUntil(){
        logFunc(#function)
        let sourceSequence = PublishSubject<Int>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .skipUntil(referenceSequence)
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sourceSequence.onNext(1)
        sourceSequence.onNext(2)
        sourceSequence.onNext(3)
        print("参照序列发射元素")
        referenceSequence.onNext("🔴")
        
        sourceSequence.onNext(4)
        sourceSequence.onNext(5)
        sourceSequence.onNext(6)
    }
    //参照序列异常终止，则最终序列会异常终止，不会发射任何数据。
    func skipUntilWithRefSeqError(){
        logFunc(#function)
        let sourceSequence = PublishSubject<Int>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .skipUntil(referenceSequence)
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sourceSequence.onNext(1)
        sourceSequence.onNext(2)
        sourceSequence.onNext(3)
        print("参照序列异常终止")
        referenceSequence.onError(ExampleError)
        
        sourceSequence.onNext(4)
        sourceSequence.onNext(5)
        sourceSequence.onNext(6)
    }
    //参照序列正常终止，则最终序列不会发射任何数据也不会终止
    func skipUntilWithRefSeqComplete(){
        logFunc(#function)
        let sourceSequence = PublishSubject<Int>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .skipUntil(referenceSequence)
            .subscribe{ print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sourceSequence.onNext(1)
        sourceSequence.onNext(2)
        sourceSequence.onNext(3)
        print("参照序列正常终止")
        referenceSequence.onCompleted()
        
        sourceSequence.onNext(4)
        sourceSequence.onNext(5)
        sourceSequence.onNext(6)
    }
    /*
     该操作符接收一个用于‘采样’的序列，采样序列会不定时采样（RxSwfit中的实现是当采样序列发射数据时，则对原始序列进行采样），采得的数据会通过最终序列发射。
     原始序列或采样序列终止，则最终序列终止。
     */
    func sample(){
        logFunc(#function)
        let sourceSeq = Observable<Int>.create { (observer) -> Disposable in
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if i <= 5{
                    print("原始序列发射数据:\(i) [第 \(i) 秒]")
                    observer.onNext(i)
                }else{
                    observer.onCompleted()
                    timer.invalidate()
                }
                i = i+1
            })
            return Disposables.create()
        }
        
        let samplerSeq = Observable<String>.create { (observer) -> Disposable in
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                if i <= 3{
                    let item = String(i)+"SamplerItem"
                    print("采样序列发射数据:\(item)")
                    observer.onNext(item)
                }else{
                    observer.onCompleted()
                    timer.invalidate()
                }
                i = i+1
            })
            return Disposables.create()
        }
        sourceSeq.sample(samplerSeq).subscribe{print("订阅者接收到数据:",$0)}.disposed(by: GlobalDisposeBag)
    }
    
    /*
     '节流'：当发生函数调用时，执行函数并开始计时，指定时长内的再次调用则会被舍弃，直至计时结束。
     类比到序列中：原始序列发射数据时，如果该次发射在上一次发射的计时周期中，则最终序列不会发射该元素，如果不在，则会发射，并同时开启新计时周期。
     实际案例：
     赞->取消赞->赞->取消赞...  ，为了防止用户的疯狂点击给服务器造成不必要的压力，可以设置一个点击事件最短执行间隔，比如1s ，那么用户在1s内的多次点击只会真正触发一次点击事件。
     latest参数 ：指计时周期结束后，最终序列是否会将原始序列最近一次发射的数据发射出去（如果最近一次发射的数据与触发计时周期的那个是同一个，则不会发射），默认是 true
     下面demo演示的是 latest 为 false 的情况。
     */
    func throttle_withLastParamFalse(){
        logFunc(#function)
        Observable<Int>.create { (observer) -> Disposable in
            var i = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if i == 10{
                    print("原始序列终止: [第 \(i) 秒])")
                    observer.onCompleted()
                    timer.invalidate()
                }else{
                    print("原始序列发射数据:\(i) [第 \(i) 秒])")
                    observer.onNext(i)
                }
                i = i+1
            }).fire()
            return Disposables.create()
            }.throttle(2.5, latest: false,scheduler: MainScheduler.instance)
            .subscribe({print("观察者接收",$0)})
            .disposed(by: GlobalDisposeBag)
    }
    //latest 为 true的情况
    //注：最终序列一旦发射元素就会开始计时，所以last element 被发射的时候计时就开始了，而这个元素就会被认为是计时周期内的第一个元素。
    func throttle_withLastParamTrue(){
        logFunc(#function)
        Observable<Int>.create { (observer) -> Disposable in
            var i = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if i == 10{
                    print("原始序列终止: [第 \(i) 秒])")
                    observer.onCompleted()
                    timer.invalidate()
                }else{
                    print("原始序列发射数据:\(i) [第 \(i) 秒])")
                    observer.onNext(i)
                }
                i = i+1
            }).fire()
            return Disposables.create()
            }.throttle(2.5, scheduler: MainScheduler.instance)
            .subscribe({print("订阅者接收",$0)})
            .disposed(by: GlobalDisposeBag)
    }
    
    /*
     '防抖':每次调用函数时会开始计时，当时指定时长内未有再次调用，则会执行函数，如果指定时长内有新的调用，则重新计时。
     简单点说就是一定时间的内所有函数调用只有最后一次生效。
     类比到序列中：每次调用 onNext 时会开始计时，当时指定时长内未有再次调用，则内部会发射该元素。
     实际场景：
     对输入框的用户输入进行关键词联想，如果用户输入的过快则不请求联想接口，当用户停止输入或输入变慢时发起请求
     */
    func debounce(){
        logFunc(#function)
        let subject = PublishSubject<Int>()
        let dateFormatString = "HH:mm:ss.ms"
        let debounceSeq = subject.debounce(1, scheduler: MainScheduler.instance)
        debounceSeq.subscribe({print("观察者 received:",$0,"at time:",curDateString(dateFormatString))})
            .disposed(by: GlobalDisposeBag)
        print("call onNext 1 at time:",curDateString(dateFormatString))
        subject.onNext(1)
        print("call onNext 2 at time:",curDateString(dateFormatString))
        subject.onNext(2)
        print("call onNext 3 at time:",curDateString(dateFormatString))
        subject.onNext(3)
        delay(2) {
            print("call onNext 4 at time:",curDateString(dateFormatString))
            subject.onNext(4)
        }
    }
}

