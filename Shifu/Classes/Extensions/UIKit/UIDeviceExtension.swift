//
//  UIDeviceExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import UIKit

public extension UIDevice {
    
    var modelName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
#if targetEnvironment(simulator)
        print(ProcessInfo().environment)
        return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? identifier
#else
        return identifier
#endif
    }
    
}
