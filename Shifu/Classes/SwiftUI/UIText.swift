//
//  UIText.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/7/2.
//

import SwiftUI
import UIKit
import SwiftUIIntrospect

public struct UIText: View {
    @Binding var text:AttributedString
    public init(_ text: AttributedString){
        _text = .constant(text)
    }
    
    public init(_ text: Binding<AttributedString>){
        _text = text
    }
    
    
    struct _UIText: UIViewRepresentable{
        @Binding var text:AttributedString
        
        
        func makeUIView(context: Context) -> UILabel {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }
        
        func updateUIView(_ uiView: UILabel, context: Context) {
            uiView.attributedText = text.ns
        }
        
        typealias UIViewType = UILabel
        
        
    }
    
    public var body: some View{
        _UIText(text: $text)
            .fixedSize()
    }
}


public struct ReturnKeyTypeModifier: ViewModifier {
    let returnKeyType:UIReturnKeyType
    public func body(content: Content) -> some View {
        content
            .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17)){ tf in
                tf.returnKeyType = returnKeyType
            }
    }
}

public extension TextField{
    func returnKeyType(_ type: UIReturnKeyType = .done)-> some View{
        self.modifier(ReturnKeyTypeModifier(returnKeyType: type))
    }
}
