//
//  Utils.swift
//  RxDemo
//
//  Created by 刘杰 on 2017/11/8.
//  Copyright © 2017年 jerry. All rights reserved.
//

import Foundation
import RxSwift
let ExampleError = NSError.init(domain: "RxExampleError", code: 0, userInfo: ["msg":"这是一个示例错误"])
var GlobalDisposeBag = DisposeBag()
func clearGlobalDisposeBag(){
    GlobalDisposeBag = DisposeBag()
}
func logFunc(_ funcName: String){
    print(">>>> call func: \(funcName) <<<<")
}
func delay(_ delayTime: TimeInterval, _ action: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: action)
}
func curDateString(_ format: String) -> String{
    return { (format: String) -> DateFormatter in
        let df = DateFormatter.init()
        df.dateFormat = format
        return df
        }(format).string(from: Date())
}
extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        context?.setShouldAntialias(true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
}
extension UIColor {
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

