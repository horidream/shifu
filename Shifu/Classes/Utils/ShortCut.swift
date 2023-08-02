//
//  QuickSetter.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import UIKit
import Combine




public class ShortCut{
    public struct env{
        public static let version = UIDevice.current.systemVersion.ns.floatValue
        public static let id = Bundle.main.bundleIdentifier
        public static let width = UIScreen.main.bounds.width
        public static let height = UIScreen.main.bounds.height

        public typealias urls = FileManager.url
        public typealias paths = FileManager.path
    }
    
    @available(iOSApplicationExtension, unavailable)
    public static func endEditing(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        NotificationCenter.default.post(name: Notification.Name("shifuEndNotification"), object: nil)
    }
    
    @available(iOSApplicationExtension, unavailable)
    public static var keyWindow: UIWindow?{
        return UIApplication.shared.windows.first(where: {
            $0.isKeyWindow
        })
    }
    
    @available(iOSApplicationExtension, unavailable)
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
    
    @available(iOSApplicationExtension, unavailable)
    public static func showAlert(title:String, details:String){
        let alert = UIAlertController(title: title, message: details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        Shifu.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    @available(iOSApplicationExtension, unavailable)
    public static func showAlert(title:String, details:String, confirmBtn:String, confirmCallback:((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel button label in alert"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmBtn, style: .default, handler: confirmCallback))
        Shifu.keyWindow?.rootViewController?.present(alert, animated: true)
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
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    public static func stopNetworking(){
        loadingCount -= 1
        if(loadingCount <= 0){
            loadingCount = 0
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
//    @available(iOS 13.0, *)
//    public static func load<T: Decodable>(_ path:String, _ callback: @escaping (_ data: T?)->Void){
//        URLSession.shared.dataTaskPublisher(for: URL(string: path)!)
//            .map{
//                (result)->Data in
//                return result.data
//            }
//            .decode(type: T.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { (completion) -> Void in
//                switch completion{
//                case .finished: break
//                case .failure: callback(nil)
//                }
//
//            }, receiveValue: { (value) in
//                callback(value)
//            })
//            .retain(path)
//    }
    @available(iOS 13.0, *)
    public static func load(_ path:String, retain key:Any? = nil , _ callback: @escaping (_ data: Data?)->Void) {
        URLSession.shared.dataTaskPublisher(for: URL(string: path)!)
            .map{
                (result)->Data in
                return result.data
            }
            .sink(receiveCompletion: { (completion) -> Void in
                switch completion{
                case .finished: break
                case .failure: callback(nil)
                }
                
            }, receiveValue: { (value) in
                callback(value)
            })
            .retain(path+String.init(describing: key))
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
    class func emit(_ notification: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil){
        NotificationCenter.default.post(name: notification, object: object, userInfo: userInfo)
    }
    
    class func emit(_ notification: Notification.Name, object: Any? = nil, _ payload: Any ...){
        let userInfo = Dictionary(zip( 0 ..< payload.count, payload), uniquingKeysWith: { (first, _) in first })
        NotificationCenter.default.post(name: notification, object: object, userInfo: userInfo)
    }

    class func emit(_ notification: String, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil){
        NotificationCenter.default.post(name: notification.toNotificationName(), object: object, userInfo: userInfo)
    }
    
    class func off(_ notification:Notification.Name, object: Any? = nil)
    {
        
        if let unwatchers = notificationMap[notification]{
            unwatchers.forEach { (wrapper) in
                
                if let (name, hashed,  cb) = wrapper.payload as? (Notification.Name, Hashed<Any?>, ()->Void), name == notification, hashed == Hashed(object) || object == nil {
                    cb()
                }
            }
        }
        if(notificationMap[notification]?.count == 0){
            notificationMap.removeValue(forKey: notification)
        }
    }
    class func off(_ notification:String, object: Any? = nil){
        off(notification.toNotificationName(), object: object)
    }
    
    @discardableResult class func on(_ notification:Notification.Name, object: Any? = nil, _ block:@escaping (Notification)->Void)->(()->Void){
        let observer = NotificationCenter.default.addObserver(forName: notification, object: object, queue: .main, using: {
            (notification:Notification) in
            block(notification)
        })
        if notificationMap[notification] == nil{
            notificationMap[notification] = []
        }
        let handler = EqutableWrapper()
        let unwatch = { [weak handler] ()->Void in
            if let handler = handler, var list = notificationMap[notification],let idx = list.firstIndex(of: handler),  list.contains(handler){
                notificationMap[notification]?.remove(at: idx)
            }
            NotificationCenter.default.removeObserver(observer, name: notification, object: object)
        }

        handler.payload = (notification, Hashed(object), unwatch)
        notificationMap[notification]?.append(handler)
        return unwatch
//        let wrapped = Hashed(object)
//        NotificationCenter.default.publisher(for: notification, object: wrapped)
//            .sink{
//                block($0)
//            }
//            .retain(wrapped)
//
//        return {
//            AnyCancellable.release(key: wrapped)
//        }
    }
    
    @discardableResult class func once(_ notification:Notification.Name, object: AnyObject? = nil,  _ block:@escaping (Notification)->Void){
        let id = UUID()
        NotificationCenter.default.publisher(for: notification, object: object)
            .sink{
                block($0)
                AnyCancellable.release(key: id)
            }
            .retain(id)
    }

    @discardableResult class func on(_ notifications:[Notification.Name], object: AnyObject? = nil, _ block:@escaping (Notification)->Void)->(()->Void){
        let arr = notifications.map { notification in
            return self.on(notifications, object: object, block)
        }
        
        return {
            arr.forEach { (off) in
                off()
            }
        }
        
    }
    
    @discardableResult class func on(_ notification:String, object: Any? = nil, _ block:@escaping (Notification)->Void)->(()->Void){
        return on(notification.toNotificationName(), object: object, block);
    }
}


struct DiffableNotification:Hashable{
    static func == (lhs: DiffableNotification, rhs: DiffableNotification) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    var name:Notification.Name
    var object:Any?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        if let object = object as? AnyHashable{
            hasher.combine(object)
        }
    }
    
}

public class Ref<Value>: ObservableObject {
    @Published public var value: Value
    public init(_ value: Value){
        self.value = value
    }
}
