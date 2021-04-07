//
//  AppModelReachability.swift
//  ASN1Swift
//
//  Created by Baoli Zhai on 2021/4/7.
//

import Reachability


public protocol AppModelReachability {
    var isNetworkAvailable:Bool { get set }
    func startObserveReachability()->Void
}

@available(iOS 13.0, *)
public extension AppModelReachability where Self: AppModelBase{
    var isNetworkAvailable:Bool{
        get{
            self.getProperty("isNetworkAvailable", fallback: false)
        }
        set{
            self.setProperty("isNetworkAvailable", value: newValue)
        }
    }
    func startObserveReachability(){
        let reachability = self.getProperty("reachability", fallback: { try? Reachability() }())
        NotificationCenter.default.publisher(for: .reachabilityChanged)
            .sink { (n) in
                if let r = n.object as? Reachability
                {
                    switch(r.connection){
                    case .unavailable:
                        self.isNetworkAvailable = false
                    default:
                        self.isNetworkAvailable = true
                    }
                }
            }
            .retain("reachabilityChanged")
        try? reachability?.startNotifier()
    }
}
