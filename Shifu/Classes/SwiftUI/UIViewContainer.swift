//
//  ContainerUIView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/8/8.
//

import Foundation
import SwiftUI
import UIKit
import SceneKit

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


public struct SCNSceneContainer:UIViewRepresentable{
    
    let scene: SCNScene?
    public init(_ scene: SCNScene?){
        self.scene = scene
    }
    public func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
