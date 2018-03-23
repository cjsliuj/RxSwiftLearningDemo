//
//  FlatMapLatestDemoVC.swift
//  RxDemo
//
//  Created by jerry on 2017/11/7.
//  Copyright © 2017年 jerry. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
func searchKeyWord(keyword: String?) -> Observable<[String]>{
    return Observable<[String]>.create { (observer) -> Disposable in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (Double(arc4random() % 1000) / 1000.0), execute: {
            guard let kw = keyword else{
                observer.onNext([])
                observer.onCompleted()
                return
            }
            guard kw.lengthOfBytes(using: .utf8) > 0 else{
                observer.onNext([])
                observer.onCompleted()
                return
            }
            let sampleSuffix = [
                "aaaaa",
                "bbbbb",
                "ccccc",
                "ddddd",
                "fffff"
            ]
            let rs = sampleSuffix.map({ (ele) -> String in
                return kw+ele
            })
            observer.onNext(rs)
            observer.onCompleted()
        })
        return Disposables.create()
    }
}
class FlatMapLatestDemoVC: UIViewController {

    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var txv1: UITextView!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var txv2: UITextView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        tf1.rx.value
        .distinctUntilChanged({ (item1, item2) -> Bool in
            if item1 == nil || item2 == nil{
                return false
            }else{
                return item1! == item2!
            }
        })
        .flatMap({return searchKeyWord(keyword: $0)})
            .subscribe { [weak self] (event) in
                let rsArr = event.element!
                self?.txv1.text = rsArr.joined(separator: "\n")
        }
        .disposed(by: disposeBag)
        
        tf2.rx.value
            .distinctUntilChanged({ (item1, item2) -> Bool in
                if item1 == nil || item2 == nil{
                    return false
                }else{
                    return item1! == item2!
                }
            })
            .flatMapLatest({return searchKeyWord(keyword: $0)})
            .subscribe { [weak self] (event) in
                let rsArr = event.element!
                self?.txv2.text = rsArr.joined(separator: "\n")
            }
            .disposed(by: disposeBag)
    }
}
