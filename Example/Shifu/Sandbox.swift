//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/2.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import ShifuWebServer
import UniformTypeIdentifiers
import CoreServices
import Combine
import PencilKit
import SwiftSoup
import VisionKit
import AVKit
import WebKit



struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var a = Ref(" ")
    @State var items: [String] = ["Hello", "SwiftUI", "World", "This", "is",  "a", "flow", "layout"]
    @StateObject var cache = Cache()
    var body: some View {
        VStack{
            Text(a.value.uppercased())
                .font(.largeTitle)
            SimpleFlowText(items: $items, onTap: { txt in
                a.value = txt
                clg(a.value)
                sandbox()
            })
        }
        .padding()
        .onAppear(){
            cache.define([1]){ Int.random(in: 0...100) }
            
        }
        
    }
    
    func sandbox(){
        clg(cache.get([1]))
    }
    
    
    
}




struct Sandbox_Previews: PreviewProvider {
    static var previews: some View {
        Sandbox()
    }
}


class Cache:ObservableObject {
    @Published private(set) var value: Any?
    private var hash:Int?
    
    @discardableResult func define(_ dependencies: [(any Hashable)?], recalculation:  @escaping (()->Any?))->Any?{
        return update(dependencies, recalculation: recalculation)
    }
    
    func get(_ dependencies: [(any Hashable)?])->Any?{
        return update(dependencies)
    }
    
    @discardableResult private func update(_ dependencies: [(any Hashable)?], recalculation:  (()->Any?)? = nil)->Any?{
        var hasher = Hasher()
        for d in dependencies {
            if let d = d{
                hasher.combine(d)
            }
        }
        let latestHash = hasher.finalize()
        clg(hash == latestHash)
        if(hash != latestHash){
            value = recalculation?()
            hash = latestHash
        }
        return value
        
        
    }
}
