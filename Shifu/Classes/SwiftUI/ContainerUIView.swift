//
//  ContainerUIView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/8/8.
//

import Foundation
import SwiftUI
import UIKit

public struct ContainerUIView: UIViewRepresentable{
    let uiView: UIView
    public init(_ uiView: UIView){
        self.uiView = uiView
    }
    
    public func makeUIView(context: Context) -> UIView {
        return uiView
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
