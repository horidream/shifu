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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = """
Hello
""".attributedString(font: .systemFont(ofSize: 99), color: .red)
    @PersistToFile("a.txt") var n:String

    var body: some View {
        VStack{
            Image(.arrowUpMessageFill)
                .foregroundStyle(.blue)
                .font(.system(size: 100).bold())
                .shadow(radius: 1, x: 3, y: 3)
            
           UIText(text)
                .onTapGesture {
                    n = "\((Int(n) ?? 0) + 1)"
                    text.apply(.color(.random), .outline())
                }
            Text("\(n)")
                .id(n)
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

    }
    
    
}

public extension AnyCancellable{
    static func key(_ key:String = #file, line: Int = #line )->String{
        return key+String(line)
    }
    
    @discardableResult func retain2(_ key: @autoclosure ()->AnyHashable = AnyCancellable.key()) -> Self {
        AnyCancellable.bag[key()] = self
        return self
    }
}


@propertyWrapper
struct log<T>{
    var wrappedValue: T{
        didSet{
            clg(wrappedValue)
        }
    }
    
}

class Test{
    @log var name = "Baoli"
}
