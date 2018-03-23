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
//用于处理序列发射数据的顺序
extension OperatorsListVC{
    
    //与数组的 reduce 类似，所有元素参与'累加'运算，将最终结果发射出去。
    func reduce(){
        logFunc(#function)
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3).reduce("a", accumulator: { (aggregate, ele) -> String in
            return aggregate + String(ele)
        })
        .subscribe{ print($0) }
        .disposed(by: disposeBag)
    }
    /*
     将多个序列合并，最终序列按顺序发射各个序列发射的数据。
     只有前面的序列发射结束了，后面序列发射的数据才会被最终序列发射。
     注意的问题：当后面的序列是 'hot'序列时，此时，在前面序列发射完成前，后面序列所发射的那些数据将不会被 最终序列 发射。
     异常终止行为：当任何一个序列异常终止，则'最终序列'会异常终止。（即使是还没轮到发射的那些序列的异常终止）
     正常终止行为： 当所有序列正常终止，则'最终序列'正常终止。
     */
    func concat(){
        logFunc(#function)
        let disposeBag = DisposeBag()
        let subject1 = PublishSubject<String>.init()
        let subject2 = PublishSubject<String>.init()
        Observable<String>.concat(subject1,subject2).subscribe{print($0)}.disposed(by: disposeBag)
        
        subject1.onNext("1")
        subject1.onNext("2")
        
        subject2.onNext("这个元素将不会输出")
        
        subject1.onCompleted()
        
        subject2.onNext("a")
        subject2.onNext("b")
        subject2.onCompleted()
    }
    func concat_error(){
        logFunc(#function)
        let disposeBag = DisposeBag()
        let subject1 = PublishSubject<String>.init()
        let subject2 = PublishSubject<String>.init()
        Observable<String>.concat(subject1,subject2).subscribe{print($0)}.disposed(by: disposeBag)
        
        subject1.onNext("1")
        subject1.onNext("2")
        //即使此时最终序列还不接收 subject2 的发射数据，但是它的异常终止也会让最终序列异常终止。
        subject2.onError(ExampleError)
        
        subject1.onCompleted()
        
        subject2.onNext("a")
        subject2.onNext("b")
        subject2.onCompleted()
    }
}

