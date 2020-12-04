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
    public static func endEditing(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        NotificationCenter.default.post(name: Notification.Name("shifuEndNotification"), object: nil)
    }
    public static var keyWindow: UIWindow?{
        return UIApplication.shared.windows.first(where: {
            $0.isKeyWindow
        })
    }
    
    public static func topViewController(_ base: UIViewController? = keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
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
    
    public static func roundedCornerLayer(_ frame:CGRect, _ radius: CGFloat = 10)->CALayer{
        let parent = CALayer()
        parent.frame = frame
        parent.cornerRadius = radius
        let child = CALayer()
        child.frame = CGRect(origin: .zero, size: frame.size)
        child.cornerRadius = radius
        child.masksToBounds = true
        parent.addSublayer(child)
        
        parent.shadowOpacity = 0.3
        parent.shadowOffset = .zero
        parent.shadowRadius = 5;
        return parent
        
    }
}



var notificationMap:[Notification.Name: [EqutableWrapper]] = [Notification.Name: [EqutableWrapper]]()

public extension ShortCut{
    class func emit(_ notification: Notification.Name, userInfo: [AnyHashable: Any]? = nil){
        NotificationCenter.default.post(name: notification, object: nil, userInfo: userInfo)
    }
    
    class func off(_ notification:Notification.Name)
    {
        
        if let unwatchers = notificationMap[notification]{
            unwatchers.forEach { (wrapper) in
                if let cb = wrapper.payload as? ()->Void{
                    cb()
                }
            }
        }
        notificationMap.removeValue(forKey: notification)
    }
    
    @discardableResult class func on(_ notification:Notification.Name, _ block:@escaping (Notification)->Void)->(()->Void){
        
        let observer = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main, using: {
            (notification:Notification) in
            block(notification)
        })
        if notificationMap[notification] == nil{
            notificationMap[notification] = []
        }
        let handler = EqutableWrapper()
        let unwatch = { [weak handler] in
            if let handler = handler, var list = notificationMap[notification],let idx = list.firstIndex(of: handler),  list.contains(handler){
                list.remove(at: idx)
            }
            
            NotificationCenter.default.removeObserver(observer, name: notification, object: nil)
        }
        
        handler.payload = unwatch
        notificationMap[notification]?.append(handler)
        return unwatch
    }
    
    @discardableResult class func on(_ notifications:[Notification.Name], _ block:@escaping (Notification)->Void)->(()->Void){
        let arr = notifications.map { notification in
            return self.on(notifications, block)
        }
        
        return {
            arr.forEach { (off) in
                off()
            }
        }
        
    }
}


