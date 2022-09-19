//
//  ShifuPasteButton.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/9/19.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 16.0, *)
public struct ShifuPasteButton<T: View>: View {
    class MyPasteTarget: NSObject,UIPasteConfigurationSupporting, ObservableObject
    {
        @Published var items:[NSItemProvider] = []
        var pasteConfiguration: UIPasteConfiguration?
        func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
            return true
        }
        
        func paste(itemProviders: [NSItemProvider]) {
            items = itemProviders
        }
        
    }
    @StateObject var myTarget = MyPasteTarget()
    @State var iconAlpha:Double = 1
    @State var clickButton:UIPasteControl = UIPasteControl(configuration: with(.init()){
        $0.baseBackgroundColor = .clear
        $0.baseForegroundColor = .clear
        $0.cornerRadius = 10
    })
    let onPaste:([NSItemProvider])->Void
    let builder: ()-> T
    let backgroundColor: Color
    let foregroundColor: Color
    public init(@ViewBuilder view builder: @escaping ()-> T, foregroundColor: Color = .black, backgroundColor: Color = Shifu.Theme.backgroundColor.sui, onPaste: @escaping ([NSItemProvider])->Void ){
        self.onPaste = onPaste
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.builder = builder
    }
    public var body: some View{
        UIViewContainer(with(clickButton){
            $0.target = myTarget
            $0.publisher(for: .touchDown)
                .sink { control in
                    ta($iconAlpha).to(0.2, duration: 0.02)
                }
                .retain()
        })
        .overlay {
            ZStack{
                backgroundColor
                Group{
                    foregroundColor
                        .opacity(iconAlpha)
                    builder()
                        .opacity(iconAlpha + 0.4)
                }
            }
            .onReceive(myTarget.$items) { items in
                ta($iconAlpha).to(1, duration: 0.15)
                onPaste(items)
            }
            .allowsHitTesting(false)
        }
        .clipped()
    }
}
