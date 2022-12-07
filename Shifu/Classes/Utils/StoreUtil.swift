//
//  StoreUtil.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/12/6.
//

import Foundation
import StoreKit

public struct StoreUtil{
    static public func requestReview(_ callback: ((Bool)->Void)? = nil){
        DispatchQueue.main.async{
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                callback?(true)
            }else{
                callback?(false)
                print("can't review....")
            }
        }
    }
}
