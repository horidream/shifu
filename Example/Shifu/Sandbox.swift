//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import UniformTypeIdentifiers
import CoreServices
import Combine
import PencilKit

struct Sandbox: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @Persist("hello") var hello = "hello"
//    var persons: [Person]?{
//        get{
//            hello.parse(to: [Person].self)
//        }
//        nonmutating set{
//            hello = newValue?.stringify() ?? ""
//        }
//    }
    @State var image = UIImage(data: "@tmp/preview-1383918801199245928.png".url?.data ?? Data())!
    var body: some View {
        Image(uiImage: image)
            .background(.red)
            .onAppear{
                sandbox()
            }
            .onInjection{
                sandbox()
            }
    }
    
    
    
    func sandbox(){
        Task{
            let img = image.trimmed()
            DispatchQueue.main.async {
                withAnimation {
                    self.image = img
                    
                }
            }
            
        }
//        persons = []
//        persons?.append(Person(name: "Baoli", age: 40))
       hello = "abc"
        
        clg(pb.string, mypb().string, mypb().abc([.data])?.previewItemURL)
    }
}








class mypb{
    @Proxy(pb, \.string)
    var string: String?
    
    
    let abc = pb.previewItem(for: )
}


@propertyWrapper
public struct Proxy<EnclosingSelf, Value> {
    private let keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>
    private let target:EnclosingSelf
    public init(_ target:EnclosingSelf, _ keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>) {
        self.target = target
        self.keyPath = keyPath
        
        
    }
    
    public var wrappedValue: Value {
        get { target[keyPath: keyPath] }
        set { target[keyPath: keyPath] = newValue }
    }
    
}
