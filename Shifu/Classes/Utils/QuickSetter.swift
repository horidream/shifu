//
//  QuickSetter.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import UIKit

public class QuickSetter{
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
}