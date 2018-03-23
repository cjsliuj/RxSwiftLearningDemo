//
//  FlatMapDemoVC.swift
//  RxDemo
//
//  Created by jerry on 2017/11/6.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DemoService{
    static func login(param: Any, completion:@escaping (_ result: Any?, _ error: Error?)->Void){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            completion("",nil)
        })
    }
    static func requestPublishedVideos(param: Any, completion:@escaping (_ result: Any?, _ error: Error?)->Void){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            completion("",nil)
        })
    }
    static func requestVideoDetailInfo(param: Any, completion:@escaping (_ result: Any?, _ error: Error?)->Void){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            completion("",nil)
        })
    }
    
    static func login2(param: Any) -> Observable<Any>{
        let ob = Observable<Any>.create { (observer: AnyObserver<Any>) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                observer.onNext("登录完成")
            })
            return Disposables.create()
        }
        return ob
    }
    static func requestPublishedVideos2(param: Any) -> Observable<Any>{
        let ob = Observable<Any>.create { (observer: AnyObserver<Any>) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                observer.onNext("请求发布视频完成")
            })
            return Disposables.create()
        }
        return ob
    }
    static func requestVideoDetailInfo2(param: Any)->Observable<Any>{
        let ob = Observable<Any>.create { (observer: AnyObserver<Any>) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                observer.onNext("请求视频详细信息完成")
            })
            return Disposables.create()
        }
        return ob
    }
}
class FlatMapDemoVC: BasicTbvVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        super._ds = [
            Section(
                title: "Creating Observables",
                rows: [
                    Row(
                        title: "异步操作回调嵌套问题举例",
                        action: asynCallbackNestDemo
                    ),
                    Row(
                        title: "异步操作回调嵌套问题解决方案",
                        action: asynCallbackNestSolution
                    )
                ]
            )
        ]
    }
    //异步操作嵌套回调demo
    func asynCallbackNestDemo(){
        DemoService.login(param: "") { (result: Any?, error: Error?) in
            print("登录完成")
            DemoService.requestPublishedVideos(param: "", completion: { (result: Any?, error: Error?) in
                print("获取已发布视频列表完成")
                DemoService.requestVideoDetailInfo(param: "", completion: { (result: Any?, error: Error?) in
                    print("获取视频详细信息完成")
                })
            })
        }
    }
    //异步操作嵌套回调解决方案 demo
    func asynCallbackNestSolution(){
        DemoService.login2(param: "")
                    .flatMap { (rs: Any) -> Observable<Any> in
                        print(rs)
                        return DemoService.requestPublishedVideos2(param: "")
                    }
                    .flatMap { (rs: Any) -> Observable<Any> in
                        print(rs)
                        return DemoService.requestVideoDetailInfo2(param: "")
                    }
                    .subscribe{print($0)}
                    .disposed(by: GlobalDisposeBag)
    }
}
