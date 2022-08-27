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
    
    @State var text = "Hello"
    @PersistToFile("a.txt") var n:String
    let layout = [GridItem(.adaptive(minimum: 60))]
    var body: some View {
        VStack{
            Text(text)
//            UIViewContainer(MyImagePicker().view)
//                .frame(height: 100)
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
        Task{
            await MainActor.run {
                clg("set text to Task")
                text = "Task"
            }
            try await Task.sleep(seconds: 2)
            await MainActor.run {
                clg("set text to Main")
                text = "Main"
            }
        }
    }
    
    
}

class MyImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        clg(info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "I am a very long title string that could be trimed by the system"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func close(){
        clg("close")
        delay(10){
            
        }
    }
}



