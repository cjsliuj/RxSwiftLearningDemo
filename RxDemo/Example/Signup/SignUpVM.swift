//
//  SignUpVM.swift
//  RxDemo
//
//  Created by jerry on 2018/3/19.
//  Copyright © 2018年 jerry. All rights reserved.
//

import UIKit
import RxSwift
enum ValidateFailReason{
    case emptyInput
    case other(String)
}
enum ValidateResult {
    case validating
    case ok
    case failed(ValidateFailReason)
    var isOk: Bool {
        if case ValidateResult.ok = self {
            return true
        }else{
            return false
        }
    }
}
class SignUpVM {
    struct Input {
        //'用户名'输入流
        let username: Observable<String>
        //'密码'输入流
        let psd: Observable<String>
        //'确认密码'输入流
        let confirmPsd: Observable<String>
        //'注册按钮点击事件'输入流
        let signUpBtnTaps: Observable<Void>
    }
    struct Output {
        //'用户名验证结果'输出流
        var usernameValidateResult: Observable<ValidateResult>!
        //'密码验证结果'输出流
        var psdValidateResult: Observable<ValidateResult>!
        //'确认密码验证结果'输出流
        var confirmPsdValidateResult: Observable<ValidateResult>!
        //'注册按钮enable设置'输出流
        var signUpEnable: Observable<Bool>!
        //'登录结果'输出流
        var signInResult: Observable<Bool>!
    }
    var output: Output
    init(input: Input) {
        output = Output()
        output.usernameValidateResult = input.username
            .flatMapLatest { (username) -> Observable<ValidateResult> in
                return SignUpService.validateUsername(username: username)
            }
            .share(replay: 1)
        
        output.psdValidateResult = input.psd
            .flatMapLatest { (psd) -> Observable<ValidateResult> in
                return SignUpService.validatePsd(psd: psd)
            }
            .share(replay: 1)

        output.confirmPsdValidateResult = Observable<ValidateResult>
            .combineLatest(input.psd,
                           input.confirmPsd,
                           resultSelector: { (psd: String, confirmPsd: String) -> ValidateResult in
                                if(psd.isEmpty || confirmPsd.isEmpty){
                                    return .failed(.emptyInput)
                                }else if(psd != confirmPsd){
                                    return .failed(.other("两次密码不一致"))
                                }else{
                                    return .ok
                                }
                        })
        .share(replay: 1)
        
        output.signUpEnable = Observable<Bool>
                            .combineLatest(output.usernameValidateResult,
                                           output.psdValidateResult,
                                           output.confirmPsdValidateResult,
                                           resultSelector: { (
                                            usernameValidateResult: ValidateResult,
                                            psdValidateResult: ValidateResult,
                                            confirmPsdValidateResult: ValidateResult) -> Bool in
                                            
                                            return usernameValidateResult.isOk
                                                && psdValidateResult.isOk
                                                && confirmPsdValidateResult.isOk
                                            
        })
        struct UsernameAndPsd{
            let username: String
            let psd: String
        }
        
        let usernameAndPsdSeq: Observable<UsernameAndPsd>  = Observable.combineLatest(input.username, input.psd) { (username, psd) -> UsernameAndPsd in
            return UsernameAndPsd(username: username, psd: psd)
        }
   
        output.signInResult = input.signUpBtnTaps
                                    .withLatestFrom(usernameAndPsdSeq)
                                    .flatMapLatest {(unamePsd: UsernameAndPsd) -> Observable<(Bool,UsernameAndPsd)> in
                                        return SignUpService.signUp(username: unamePsd.username,
                                                                    psd: unamePsd.psd)
                                                             .map{ (isSignSuccess) -> (Bool,UsernameAndPsd) in
                                                                return (isSignSuccess, UsernameAndPsd(username: unamePsd.username,psd: unamePsd.psd))
                                                             }
                                    }.flatMapLatest{ (e: (isSignUpSuccess: Bool,unameAndPsd: UsernameAndPsd )) -> Observable<Bool> in
                                        if e.isSignUpSuccess{
                                            return SignUpService.signIn(username: e.unameAndPsd.username, psd: e.unameAndPsd.psd)
                                        }else{
                                            return Observable<Bool>.of(false)
                                        }
                                    }
    }
}
 








