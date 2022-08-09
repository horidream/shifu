//
//  LottieView.swift
//  ShifuLottie
//
//  Created by Baoli Zhai on 2022/8/6.
//

import Foundation
import Lottie
import SwiftUI
import Shifu

public struct LottieView: UIViewRepresentable{
    var lottieView: AnimationView
    public init(_ lottieAnimation: AnimationView) {
        self.lottieView = lottieAnimation
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let view  = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(lottieView)
        lottieView.backgroundColor = .clear
        lottieView.contentMode = .scaleAspectFit
        lottieView.quickMargin(0,0,0,0)
        return view
        
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    
    
}
