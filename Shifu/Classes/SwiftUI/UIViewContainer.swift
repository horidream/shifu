//
//  ContainerUIView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/8/8.
//

import Foundation
import SwiftUI
import UIKit

public struct UIViewContainer: UIViewRepresentable{
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

public struct UIViewControllerContainer: UIViewControllerRepresentable{
    let vc: UIViewController
    public init(_ vc: UIViewController){
        self.vc = vc
    }
    public func makeUIViewController(context: Context) -> UIViewController {
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
