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
import Lottie
import Foundation


extension Int{
    var scale:String{
        self > 66 ? "big" : self < 33 ? "small" : "medium"
    }
}

struct Sandbox:View{
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    var body: some View {
        ZStack {
            Text("hello")
            
            .padding()
        }
        .frame(height: 200)
        .cornerRadius(10)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            sandbox()
        }
        .onInjection{
            sandbox()
        }
    }
    
    func sandbox(){
       
    }
    
}



class File{
    var filename:String
    var data:String
    init(filename: String, data: String) {
        self.filename = filename
        self.data = data
    }
}

class VersionedFile: File{
    var version:Double = 0
    convenience init(filename: String, data: String, version: Double = 1) {
        self.init(filename: filename, data: data)
        self.version = version
    }
}

class BookFile: VersionedFile {
    private var author: String?
}

class MyFile: BookFile{
    func say(){
        clg("self")
    }
}
