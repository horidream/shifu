//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit
import ShifuLottie


struct Sandbox:View{
   
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = [].attributedString()
    @StateObject var props = TweenProps()
    var body: some View {
        VStack {
            ThemePicker()
            UIText(text)
                .onTapTarget {
                    tween($props, from: [
                         \.rotationY: 89,
                         \.scale: 0.2,
                         \.alpha: 0.3,
                         \.blur: 10
                         
                    ], to: [
//                        \.rotationY: "180",
                         \.x : 0
                    ], duration: 1,  type: .custom(TweenAnimationType.back.raw.repeatCount(2, autoreverses: true)))
                    pb.image = $0.snapshot( backgroundColor: .green)
                }
                
            
            Spacer()
            SimpleMarkdownViewer(content: #"""
```swift
text = ["Hi", "Swift", "\nMay the force \nbe with you"]
    .attributedString([
        .font: UIFont.boldSystemFont(ofSize: 28),
        .foregroundColor: UIColor.lightGray,
        .paragraphStyle: with(NSMutableParagraphStyle()){ $0.alignment = .center }
        ], attributes:[
            [.foregroundColor: Theme.titlePrimary, .font: UIFont.boldSystemFont(ofSize: 96), .strokeColor: Theme.titleSecondary, .strokeWidth: NSNumber(-2)]
    ])
text.replace("Swift", with: Icons.image(.swift_fa, color: .red).attributedString([.baselineOffset: -3]))
```
"""#, css: "pre{ margin-top: 5px; }")
            .id(injectObserver.injectionNumber)
        }
        .tweenProps(props)

        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        text = ["Hi", "Swift", "\nMay the force \nbe with you"].attributedString([.font: UIFont.boldSystemFont(ofSize: 28), .foregroundColor: UIColor.lightGray, .paragraphStyle: with(NSMutableParagraphStyle()){ $0.alignment = .center }], attributes:[
            [.foregroundColor: Theme.titlePrimary, .font: UIFont.boldSystemFont(ofSize: 96), .strokeColor: Theme.titleSecondary, .strokeWidth: NSNumber(-2)],
            nil
        ])
        text.replace("Swift", with: Icons.image(.swift_fa, color: .red).attributedString([.baselineOffset: -3]))
    }

}

extension View {
    func onTapTarget(_ callback: @escaping (Self)->Void)->some View{
        return self.onTapGesture {
            callback(self)
        }
    }
    
}
private class ObservedObjectCollectionBox<Element>: ObservableObject where Element: ObservableObject {
    private var subscription: AnyCancellable?
    
    init(_ wrappedValue: AnyCollection<Element>) {
        self.reset(wrappedValue)
    }
    
    func reset(_ newValue: AnyCollection<Element>) {
        self.subscription = Publishers.MergeMany(newValue.map{ $0.objectWillChange })
            .eraseToAnyPublisher()
            .sink { _ in
                self.objectWillChange.send()
            }
    }
}

@propertyWrapper
public struct ObservedObjectCollection<Element>: DynamicProperty where Element: ObservableObject {
    public var wrappedValue: AnyCollection<Element> {
        didSet {
            if isKnownUniquelyReferenced(&observed) {
                self.observed.reset(wrappedValue)
            } else {
                self.observed = ObservedObjectCollectionBox(wrappedValue)
            }
        }
    }
    
    @ObservedObject private var observed: ObservedObjectCollectionBox<Element>

    public init(wrappedValue: AnyCollection<Element>) {
        self.wrappedValue = wrappedValue
        self.observed = ObservedObjectCollectionBox(wrappedValue)
    }
    
    public init(wrappedValue: AnyCollection<Element>?) {
        self.init(wrappedValue: wrappedValue ?? AnyCollection([]))
    }
    
    public init<C: Collection>(wrappedValue: C) where C.Element == Element {
        self.init(wrappedValue: AnyCollection(wrappedValue))
    }
    
    public init<C: Collection>(wrappedValue: C?) where C.Element == Element {
        if let wrappedValue = wrappedValue {
            self.init(wrappedValue: wrappedValue)
        } else {
            self.init(wrappedValue: AnyCollection([]))
        }
    }
}
