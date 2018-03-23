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
     将原始序列中的数据打包成数组，由最终序列发射出去。
     需要原始序列正常终止后，才会打包发射。
     如果原始序列异常终止，则最终序列也会异常终止。
     */
    func toArray(){
        logFunc(#function)
        let seq = Observable<Int>.create { (observer) -> Disposable in
            var i = 1
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if i <= 4{
                    observer.onNext(i)
                    i = i+1
                }else{
                    observer.onCompleted()
                    //如果是 error ，则不会发射元素，只会发射 error 事件。
                }
            }).fire()
            return Disposables.create()
            }.toArray()
        print("开始订阅, time:", Date())
        seq.subscribe{print("接收到数据: ",$0," time: ",Date())}.disposed(by: GlobalDisposeBag)
    }
}

