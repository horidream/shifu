//
//  CloudUtil.swift
//  Pods
//
//  Created by Baoli Zhai on 16/05/2017.
//
//

import Foundation

func isICloudContainerAvailable()->Bool {
    // ubiquityIdentityToken: An opaque token that represents the current user’s iCloud identity
    if let currentToken = FileManager.default.ubiquityIdentityToken {
        return true
    }
    else {
        return false
    }
}
