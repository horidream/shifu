//
//  UITraitCollectionExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import UIKit

extension UITraitCollection {
    
    var isIpad: Bool {
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var isIphoneLandscape: Bool {
        return verticalSizeClass == .compact
    }
    
    var isIphonePortrait: Bool {
        return horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
    
    var isIphone: Bool {
        return isIphoneLandscape || isIphonePortrait
    }
}
