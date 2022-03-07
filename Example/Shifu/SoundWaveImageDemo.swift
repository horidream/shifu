//
//  SoundWaveImageDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct SoundWaveImageDemo: View {
    @StateObject var webViewModel = ShifuWebViewModel()
    @ObservedObject private var injectObserver = Self.injectionObserver
    var url =  Bundle.main.url(forResource: "source/test", withExtension: "mp3") ?? URL(fileURLWithPath: "")
    @State var image = UIImage()
    var body: some View {
        ScrollView{
            Image(uiImage: image)
                .resizable()
                .aspectRatio(4, contentMode: .fit)
                .padding()
                .cornerRadius(15)
                .padding()
            MarkdownView(viewModel: webViewModel,  content: .constant( "@source/SoundWaveImageDemo.md".url?.content ?? ""))
                .autoResize()
                .padding()
        }
        .onAppear(perform: drawWave)
        .onInjection {
            drawWave()
        }
    }
    
    func drawWave(){
        let waveformImageDrawer = WaveformImageDrawer()
        waveformImageDrawer.waveformImage(fromAudioAt: url, with: .init(
            size: CGSize(300, 150),
            style: .gradient([.red, .orange]),
            position: .middle,
            verticalScalingFactor: 0.5)) { image in
                // need to jump back to main queue
                DispatchQueue.main.async {
                    if let image = image{
                        self.image = image
                    }
                }
            }
    }
}


