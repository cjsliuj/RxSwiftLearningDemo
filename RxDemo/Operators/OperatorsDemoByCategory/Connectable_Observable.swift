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
     'Connectable序列' 是一种特别的序列，它可以更精确的动态的控制订阅行文。
     Connectable 序列并不会在观察者订阅时就开始发射数据，而是需要主动调用 connect() 函数以开始发射数据。
     并且订阅行为不会触发序列的被订阅逻辑（shares a single subscription to the underlying sequence.）
     */
    /*
     将普通序列转换成 Connectable 序列
     */
    func publish(){
        logFunc(#function)
        //此时订阅后，并不会让序列发射元素
        let seq = Observable<Int>.of(1,2,3).publish()
        seq.subscribe{ print($0) }.disposed(by: DisposeBag())
    }
    
    //使序列开始发射数据
    func connect(){
        logFunc(#function)
        let seq = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
        seq.subscribe{ print("观察者1:",$0) }.disposed(by: GlobalDisposeBag)
        seq.connect().disposed(by: GlobalDisposeBag)
        //后续的订阅会 shares single subscription
        delay(3) {
            seq.subscribe{ print("观察者2:",$0) }.disposed(by: GlobalDisposeBag)
        }
        //后续的订阅会 shares single subscription
        delay(5) {
            seq.subscribe{ print("观察者3:",$0) }.disposed(by: GlobalDisposeBag)
        }
    }
    func without_connect(){
        logFunc(#function)
        let seq = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        seq.subscribe{ print("观察者1:",$0) }.disposed(by: GlobalDisposeBag)
        //后续订阅并不会创建新的发射序列
        delay(3) {
            seq.subscribe{ print("观察者2:",$0) }.disposed(by: GlobalDisposeBag)
        }
        //后续订阅并不会创建新的发射序列
        delay(5) {
            seq.subscribe{ print("观察者3:",$0) }.disposed(by: GlobalDisposeBag)
        }
    }
    
    //观察者订阅时，序列会将先前发射过的最近N个数据先发射给观察者
    func replay(){
        logFunc(#function)
        let seq = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(2)
        seq.subscribe{ print("订阅者1 接收到数据:",$0) }.disposed(by: GlobalDisposeBag)
        seq.connect().disposed(by: GlobalDisposeBag)
        delay(3) {
            seq.subscribe{ print("订阅者2 接收到数据:",$0) }.disposed(by: GlobalDisposeBag)
        }
        //会接收到订阅前发射的最近3个元素
        delay(5) {
            seq.subscribe{ print("订阅者3 接收到数据",$0) }.disposed(by: GlobalDisposeBag)
        }
    }
    //观察者订阅时，序列会将先前发射过的数据全部先发射给观察者
    func replayAll(){
        logFunc(#function)
        let seq = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replayAll()
        seq.subscribe{ print("订阅1:",$0) }.disposed(by: GlobalDisposeBag)
        seq.connect().disposed(by: GlobalDisposeBag)
        delay(3) {
            seq.subscribe{ print("订阅2:",$0) }.disposed(by: GlobalDisposeBag)
        }
        delay(5) {
            seq.subscribe{ print("订阅3:",$0) }.disposed(by: GlobalDisposeBag)
        }
        
    }
    //数据会通过指定的Subject发射给订阅者
    func multicast(){
        logFunc(#function)
        let subject = PublishSubject<Int>()
        _ = subject
            .subscribe{ print("Subject 观察者: \($0)") }
        
        let intSequence = Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .multicast(subject)
        
        intSequence.subscribe{ print("\tintSequence观察者 1:, Event: \($0)") }.disposed(by: GlobalDisposeBag)
        intSequence.subscribe{ print("\tintSequence观察者 2:, Event: \($0)") }.disposed(by: GlobalDisposeBag)
        intSequence.subscribe{ print("\tintSequence观察者 3:, Event: \($0)") }.disposed(by: GlobalDisposeBag)
        
        //2秒后开始发射数据
        delay(2) { intSequence.connect().disposed(by: GlobalDisposeBag)}
       
        //subject，5 秒后终止
        delay(5) {
            subject.onCompleted()
        }
        
    }
}

