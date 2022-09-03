//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 4022/3/13.
//  Copyright © 4022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit
import ShifuLottie
import MobileCoreServices
import UniformTypeIdentifiers
import SceneKit


struct Sandbox:View{
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = "Hello"
    @PersistToFile("a.txt") var n:String
    @State var scene: SCNScene? = .init(named: "chair.scn")
    let layout = [GridItem(.adaptive(minimum: 60))]
    @State var currentSelected: Int = 1
    @Namespace var animation
    @State var p:CGFloat = 0
    var currency: String = "USD"
    var body: some View {
        VStack{
            Text("Demo SCNScene")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.gray)
            ZStack(alignment: .bottomTrailing){
                SCNSceneContainer(scene: $scene)
                    .background(.blue)
                    .frame(maxHeight: 300)
                    .onTapGesture {
                        ta($p).from(0, to: 1, type: .custom(.linear(duration: 10).repeatForever(autoreverses: false)))
                    }
                Text("\(currentSelected)")
                    .fontWeight(.black)
                    .frame(width: 100)
                    .padding(12)
                    .foregroundColor(.gray)
                    .background{
                        Circle()
                            .foregroundColor(.white)
                    }
                    .padding(10, -30)
            }
            ScrollView(.horizontal){
                LazyHStack(spacing: 10){
                    let sizes = 1...100
                    ForEach(sizes, id: \.self){ size in
                        Text("\(size)")
//                            .frame(width: 30)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(
                                ZStack{
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill( .gray)
                                    
                                    if currentSelected == size {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill( .blue)
                                            .matchedGeometryEffect(id: "ABC", in: animation)
                                        
                                    }
                                    
                                }
                            )
                            
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.1)) {
                                    currentSelected = size
                                    
                                }
                            }
                    }
                }
                .frame(height: 30)
                .padding()
            }
            Rectangle()
                .trim(from: 0, to: p)
                .stroke(.black, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                .padding()
//                .frame(height: 40)
            
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
            
        }
    }
    

    
   
    class Person{
        var name = "Baoli"
        lazy var doSth: ()->Void = { [ txt = name] in
            clg(txt) // Baoli
        }
    }
    
    func sandbox(){
        
        
    }
    
    

}





struct SCNSceneContainer:UIViewRepresentable{
    @Binding var scene: SCNScene?
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


