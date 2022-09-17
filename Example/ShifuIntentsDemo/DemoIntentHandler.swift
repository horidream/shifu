//
//  DemoIntentHandling.swift
//  ShifuIntentsDemo
//
//  Created by Baoli Zhai on 2022/9/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Intents
import Shifu

class DemoIntentHandler: NSObject, DemoIntentHandling{
    func handle(intent: DemoIntent, completion: @escaping (DemoIntentResponse) -> Void) {
        
        completion(.success(name: ud.string(forKey: "myname") ?? "Baoli"))
    }
    

    
    
}
