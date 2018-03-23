//
//  SignUpService.swift
//  RxDemo
//
//  Created by jerry on 2018/3/20.
//  Copyright © 2018年 jerry. All rights reserved.
//

import UIKit
import RxSwift
extension String{
    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
    func contains(characters: CharacterSet) -> Bool{
        return self.rangeOfCharacter(from: characters) != nil
    }
}
class SignUpService {
    static func validateUsername(username: String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if username.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            anyObserver.onNext(.validating)
            print("发起'用户名'验证请求...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                if username.count < 6 && username.count > 0{
                    anyObserver.onNext(.failed(.other("用户名不能少于6个字符")))
                }else if(username.trim().contains(characters: CharacterSet(charactersIn: " !@#$%^&*()"))){
                    anyObserver.onNext(.failed(.other("用户名有特殊字符")))
                }else{
                    anyObserver.onNext(.ok)
                }
                anyObserver.onCompleted()
            })
            return Disposables.create()
        }
    }
    static func validatePsd(psd: String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if psd.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            anyObserver.onNext(.validating)
            print("发起'密码'验证请求...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                if psd.count < 6 && psd.count > 0{
                    anyObserver.onNext(.failed(.other("密码不能少于6个字符")))
                }else if(psd.trim().contains(characters: CharacterSet(charactersIn: " !@#$%^&*()"))){
                    anyObserver.onNext(.failed(.other("密码有特殊字符")))
                }else{
                    anyObserver.onNext(.ok)
                }
                anyObserver.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    static func signUp(username: String, psd: String) -> Observable<Bool>{
        return Observable<Bool>.create { (anyObserver) -> Disposable in
            print("发起'注册'请求...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                anyObserver.onNext(true)
                anyObserver.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    static func signIn(username: String, psd: String) -> Observable<Bool>{
        return Observable<Bool>.create { (anyObserver) -> Disposable in
            print("发起'登录'请求...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                anyObserver.onNext(true)
                anyObserver.onCompleted()
            })
            return Disposables.create()
        }
    }
}
