//
//  SubjectMainVC.swift
//  RxDemo
//
//  Created by jerry on 2017/11/5.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
 Subject可以看成是一个桥梁或者代理，在某些ReactiveX实现中（如RxJava），它同时充当了Observer和Observable的角色。
 因为它是一个 Observer，它可以订阅一个或多个Observable；
 又因为它是一个 Observable，它可以转发它收到(做为Observer时)的数据，也可以发射新的数据。
 
 由于一个 Subject 订阅一个Observable，所以它可以触发 Observable 开始发射数据（如果那个Observable是"冷"的--就是说，它等待有订阅才开始发射数据）。
 因此有这样的效果，Subject可以把原来那个"冷"的Observable变成"热"的。
 */
class SubjectMainVC: BasicTbvVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RxSwiftDemo"
        super._ds = [
            Section(
                title: "",
                rows: [
                    Row(
                        title: "PublishSubject",
                        action: publishSubject
                    ),
                    Row(
                        title: "ReplaySubject",
                        action: replaySubject
                    ),
                    Row(
                        title: "BehaviorSubject",
                        action: behaviorSubject
                    ),
                    Row(
                        title: "Variable",
                        action: variable
                    )
                ]
            )
        ]
    }
    //观察者只会接收到订阅时间点以后序列发射的数据。
    func publishSubject(){
        let subject = PublishSubject<String>()
        subject.subscribe{ print("观察者1 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.subscribe{ print("观察者2 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        subject.onNext("c")
        subject.onNext("d")
        subject.onCompleted()
        subject.subscribe{ print("观察者3 接收到:",$0) }.disposed(by: GlobalDisposeBag)
    }
    //相比 publishSubject ，观察者会额外接收到订阅前最近发射的 N 条数据。
    func replaySubject(){
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        subject.subscribe{ print("观察者1 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.subscribe{ print("观察者2 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        subject.onNext("d")
        subject.onCompleted()
        subject.subscribe{ print("观察者3 接收到:",$0) }.disposed(by: GlobalDisposeBag)
    }
    //相比 publishSubject, 观察者会额外接收到订阅前最近发射的最近一条数据，如果订阅时还没有数据发射，那么会收到一个初始数据。
    func behaviorSubject(){
        let subject = BehaviorSubject(value: "初始数据")
        subject.subscribe{ print("观察者1 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.subscribe{ print("观察者2 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        subject.onNext("d")
        subject.onCompleted()
        subject.subscribe{ print("观察者3 接收到:",$0) }.disposed(by: GlobalDisposeBag)
    }
    /*
        Variable 内部封装了 BehaviorSubject，所以其发射行为与 BehaviorSubject 类似。
        不同之处是，Variable 会在序列被释放前自动发射一个 complete 事件（正常终止）。
        同时 Variable 永远不会发射 error事件(异常终止)。
     */
    func variable(){
        var variable: Variable! = Variable("初始数据")
        variable.asObservable().subscribe{ print("观察者1 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        variable.value = "1"
        variable.value = "2"
        
        variable.asObservable().subscribe{ print("观察者2 接收到:",$0) }.disposed(by: GlobalDisposeBag)
        variable.value = "3"
        variable.value = "4"
        delay(2) {
            variable = nil
        }
    }
}


