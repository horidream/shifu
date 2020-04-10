//
//  QuickSetter.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import UIKit
import RxSwift
import RxCocoa

public class ShortCut{
    public static func showAlert(title:String, details:String){
        let alert = UIAlertController(title: title, message: details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    public static func showAlert(title:String, details:String, confirmBtn:String, confirmCallback:((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel button label in alert"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmBtn, style: .default, handler: confirmCallback))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    public static func clearUserDefaults(){
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    @available(iOS 9.0, *)
    public static func animateIn(layer:CALayer){
        let ba = CASpringAnimation(keyPath: "transform.scale")
        ba.fromValue = 0.7
        ba.duration = 0.7
        layer.add(ba, forKey: nil)
    }
    
    private static var loadingCount = 0
    public static func startNetworking(){
        if loadingCount == 0{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    public static func stopNetworking(){
        loadingCount -= 1
        if(loadingCount <= 0){
            loadingCount = 0
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    public static func load(_ path:String, _ callback: @escaping (_ data: Data)->Void)->Disposable{
        return URLSession.shared.rx
            .response(request: URLRequest(url: URL(string: path)!))
            .subscribe(onNext:{
                _, data in
                DispatchQueue.main.async{
                    callback(data)
                }
            })
    }
    
    @available(iOS 9.0, *)
    public static func button(_ title: String, handler: @escaping (UIButton)-> ())->UIButton{
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.sizeToFit()
        btn.addAction(action: handler)
        return btn;
    }
}
