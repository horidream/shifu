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
import Vision
import CoreImage


struct SceneAndPerson:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    let scene: SCNScene? = .init(named: "chair.scn")
    let layout = [GridItem(.adaptive(minimum: 60))]
    @State var currentSelected: Int = 1
    @Namespace var animation
    @State var p:CGFloat = 0
    var currency: String = "USD"
    @State var img = UIImage(named: "ningning")
    var body: some View {
        VStack{
            Text("Demo SCNScene")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.gray)
            ZStack(alignment: .bottomLeading){
                SCNSceneContainer(scene)
                    .background(.purple)
                    
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
                HStack{
                    Spacer()
                    (img?.personSnapshot()?.stroked(.white, width: -10).sui ?? Image(uiImage: UIImage()))
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .padding(.top, 60)
                        .padding(.bottom, -10)
                        .shadow(radius: 4)
                    
                }
                
                
            }
            .frame(maxHeight: 300)
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
            .padding()
            .shadow(radius: 3)
            ScrollView(.horizontal){
                LazyHStack(spacing: 10){
                    let sizes = 1...10
                    ForEach(sizes, id: \.self){ size in
                        Text("\(size)")
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
            ZStack(alignment: .top){
                SimpleMarkdownViewer(content: #"""
                    ##
                    ```swift
                     // 扣图， 外轮廓线（负值为包含原图）
                     img?.personSnapshot()?
                        .stroked(.white, width: -10)
                        .sui ?? Image(uiImage: UIImage())
                    ```
                    """#)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius:  20)
                        .trim(from: 0, to: p)
                        .stroke(.purple, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                        .offset(y: -10)
                }
                .padding()
            }
            .onTapGesture {
                ta($p).from(0, to: 1, type: .custom(.linear(duration: 10).repeatForever(autoreverses: false)))
            }
            Spacer()
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    

    

    
    func sandbox(){
//        n = "ok"
        
    }
    
    

}










