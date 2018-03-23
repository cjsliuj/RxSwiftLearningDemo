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
     当捕获到 error 事件后，序列会用预先设置好的数据发射出去，然后正常终止。
     */
    func catchErrorJustReturn(){
        logFunc(#function)
        let sequenceThatFails = PublishSubject<String>()
        
        sequenceThatFails
            .catchErrorJustReturn("Catch it")
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sequenceThatFails.onNext("1")
        sequenceThatFails.onNext("2")
        sequenceThatFails.onError(ExampleError)
        sequenceThatFails.onNext("3")
        sequenceThatFails.onNext("4")
    }
    /*
     当捕获到 error 事件后，切换到另外一个序列发射数据
     */
    func catchError(){
        logFunc(#function)
        let sequenceThatFails = PublishSubject<String>()
        let recoverySequence = PublishSubject<String>()
        
        sequenceThatFails
            .catchError {_ in
                return recoverySequence
            }
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
        
        sequenceThatFails.onNext("1")
        sequenceThatFails.onNext("2")
        sequenceThatFails.onNext("3")
        sequenceThatFails.onNext("4")
        sequenceThatFails.onError("Some Error")
        recoverySequence.onNext("r3")
        recoverySequence.onNext("r4")
    }
    //当序列发出 error 事件后，会重新订阅序列，以让该序列重新发射数据。
    func retry(){
        logFunc(#function)
        var count = 1
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("1")
            observer.onNext("2")
            observer.onNext("3")
            
            if count == 1 {
                observer.onError(ExampleError)
                count += 1
            }
            
            observer.onNext("4")
            observer.onNext("5")
            observer.onNext("6")
            observer.onCompleted()
            
            return Disposables.create()
        }
        sequenceThatErrors
            .retry()
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //与 retry 行为一样，只是多了一个最多尝试次数的限制
    func retryMaxAttemptCount(){
        logFunc(#function)
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("1")
            observer.onNext("2")
            observer.onNext("3")
            
            observer.onError(ExampleError)
            
            observer.onNext("4")
            observer.onNext("5")
            observer.onNext("6")
            observer.onCompleted()
            return Disposables.create()
        }
        sequenceThatErrors
            .retry(3)
            .subscribe { print($0) }
            .disposed(by: GlobalDisposeBag)
    }
    //序列失败时，等待'通知序列'发射元素，一旦'通知序列'发射数据，原始序列则会进行retry操作，如果通知序列正常或异常终止，则原始序列同样正常或异常终止。
    func retryWhen(){
        logFunc(#function)
        let notifyer = PublishSubject<String>()
        var count = 1
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("1")
            observer.onNext("2")
            observer.onNext("3")
            if count == 1{
                observer.onError("Some Error")
                count = count + 1
            }
            observer.onNext("4")
            observer.onNext("5")
            observer.onNext("6")
            observer.onCompleted()
            return Disposables.create()
        }
        sequenceThatErrors
            .retryWhen({ (errorSeq:Observable<Error>) -> Observable<String> in
                return notifyer
            })
            .subscribe { print("接收到数据: ",$0," time: ",Date()) }
            .disposed(by: GlobalDisposeBag)
        
        delay(2) {
            print("通知序列发射元素, time: ", Date())
            notifyer.onNext("a")
            //notifyer.onCompleted() //以 Completed 事件结束
            //notifyer.onError("Some Error") // 以 error 事件结束
        }
    }
}

