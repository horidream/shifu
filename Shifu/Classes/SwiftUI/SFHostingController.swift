//
//  ShifuTextEditor.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/19.
//

import SwiftUI

public class SFHostingController<Content>: UIHostingController<Content> where Content: View {
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed || isMovingFromParent {
            // Your custom logic here
            sc.emit("dismiss", object: self)
        }
    }
}

