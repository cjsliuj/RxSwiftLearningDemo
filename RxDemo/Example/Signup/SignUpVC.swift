//
//  SignUpVC.swift
//  RxDemo
//
//  Created by 刘杰 on 2018/3/19.
//  Copyright © 2018年 jerry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    let _bag: DisposeBag = DisposeBag()
    @IBOutlet weak var _usernameTf: UITextField!
    @IBOutlet weak var _psdTf: UITextField!
    @IBOutlet weak var _confirmPsdTf: UITextField!
    @IBOutlet weak var _signUpBtn: UIButton!
    
    @IBOutlet weak var _usernameValidationLb: UILabel!
    @IBOutlet weak var _psdValidationLb: UILabel!
    @IBOutlet weak var _confirmPsdValidationLb: UILabel!
    
    var _vm: SignUpVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        _vm = SignUpVM(input: SignUpVM.Input(
            username: _usernameTf.rx.value
                                    .orEmpty
                                    .asObservable()
                                    .distinctUntilChanged()
                                    .debounce(0.5, scheduler: MainScheduler.instance),
            
            psd: _psdTf.rx.value
                          .orEmpty
                          .asObservable()
                          .distinctUntilChanged()
                          .debounce(0.5, scheduler: MainScheduler.instance),
            
            confirmPsd: _confirmPsdTf.rx.value
                                        .orEmpty
                                        .asObservable()
                                        .distinctUntilChanged()
                                        .debounce(0.5, scheduler: MainScheduler.instance),
            
            signUpBtnTaps: _signUpBtn.rx.tap.asObservable()
        ))

        _vm.output.usernameValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_):
                self?._usernameValidationLb.text = "验证服务出错";
                self?._usernameValidationLb.textColor =  UIColor.red
            case .next(let result):
                switch result{
                case .ok:
                    self?._usernameValidationLb.textColor =  UIColor.black
                    self?._usernameValidationLb.text = ""
                case .validating:
                    self?._usernameValidationLb.textColor =  UIColor.brown
                    self?._usernameValidationLb.text = "验证中..."
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?._usernameValidationLb.text = ""
                    case .other(let msg):
                        self?._usernameValidationLb.textColor =  UIColor.red
                        self?._usernameValidationLb.text = msg
                    }
                }
            }
        }.disposed(by: _bag)
        
        _vm.output.usernameValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_):
                self?._usernameValidationLb.text = "验证服务出错";
                self?._usernameValidationLb.textColor =  UIColor.red
            case .next(let result):
                switch result{
                case .ok:
                    self?._usernameValidationLb.textColor =  UIColor.black
                    self?._usernameValidationLb.text = ""
                case .validating:
                    self?._usernameValidationLb.textColor =  UIColor.brown
                    self?._usernameValidationLb.text = "验证中..."
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?._usernameValidationLb.text = ""
                    case .other(let msg):
                        self?._usernameValidationLb.textColor =  UIColor.red
                        self?._usernameValidationLb.text = msg
                    }
                }
            }
            }.disposed(by: _bag)
        
        _vm.output.psdValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_):
                self?._psdValidationLb.text = "验证服务出错";
                self?._psdValidationLb.textColor =  UIColor.red
            case .next(let result):
                switch result{
                case .ok:
                    self?._psdValidationLb.textColor =  UIColor.black
                    self?._psdValidationLb.text = ""
                case .validating:
                    self?._psdValidationLb.textColor =  UIColor.brown
                    self?._psdValidationLb.text = "验证中..."
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?._psdValidationLb.text = ""
                    case .other(let msg):
                        self?._psdValidationLb.textColor =  UIColor.red
                        self?._psdValidationLb.text = msg
                    }
                }
            }
        }.disposed(by: _bag)
        
        _vm.output.confirmPsdValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_):
                self?._psdValidationLb.text = "验证服务出错";
                self?._psdValidationLb.textColor =  UIColor.red
            case .next(let result):
                switch result{
                case .ok:
                    self?._confirmPsdValidationLb.textColor =  UIColor.black
                    self?._confirmPsdValidationLb.text = ""
                case .validating:
                    self?._confirmPsdValidationLb.textColor =  UIColor.brown
                    self?._confirmPsdValidationLb.text = "验证中..."
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?._confirmPsdValidationLb.text = ""
                    case .other(let msg):
                        self?._confirmPsdValidationLb.textColor =  UIColor.red
                        self?._confirmPsdValidationLb.text = msg
                    }
                }
            }
        }.disposed(by: _bag)
        
        _vm.output.signUpEnable.subscribe(onNext: { [weak self] (isEnable) in
            self?._signUpBtn.isEnabled = isEnable
            self?._signUpBtn.alpha = isEnable ? 1 : 0.5
        }).disposed(by: _bag)
//
        _vm.output.signInResult.subscribe(onNext: { [weak self] (isSignInSuccess) in
            if(isSignInSuccess){
                QuickAlert.alert(title: "提示", message: "注册成功", btnTitle: "知道了", btnAction: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }, onError: { (error) in
            QuickAlert.alert(title: "提示", message: "注册失败", btnTitle: "知道了", btnAction:nil)
        }).disposed(by: _bag)
    }
}
