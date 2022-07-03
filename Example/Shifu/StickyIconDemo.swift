//
//  StickViewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/7/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import Combine

struct StickyIconDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var shouldAutoPlay = false
    @State var image = Icons.Name.swift_fa{
        didSet{
            tween($props, to: [\.scale: 0.73])
            delay(0.3){
                tween($props, to: [\.scale: 1], type: .back)
            }
        }
    }
    @State var iconColor:Color = Theme.iconColor.swiftUIColor
    @StateObject var props = TweenProps()
    @State var observation: NSKeyValueObservation?
    
    var body: some View {
        VStack(alignment: .center) {
            ThemePicker()
                .padding(0, 12)
            
            StickyIcon(image: $image, color: $iconColor , maxRadius: 35)
                .tweenProps(props)
                .onTapGesture {
                    image = .random
                    //            iconColor = .random
                }
            SimpleMarkdownViewer(content: """
```swift
class Theme{
    @ThemedColor(light: .red, dark: .random)
    public static var iconColor
}
```
""", animated: false,  css: "pre { margin: 10px } ")
            .frame(height: 100)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    shouldAutoPlay.toggle()
                    if shouldAutoPlay {
                        
                        Timer.publish(every: 1.2, on: .current, in: .common)
                            .autoconnect()
                            .sink { _ in
                                image = .random
                                
                            }
                            .retain("timer")
                        image = .random
                    } else {
                        AnyCancellable.release(key: "timer")
                        
                    }
                    
                    
                } label: {
                    Image.icon( shouldAutoPlay ? .pause_fa : .play_fa)
                        .frame(width: 16, height: 16)
                        .offset(x: shouldAutoPlay ? 0 : 2)
                        .padding(8)
                        .overlay {
                            Circle() // or RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 3)
                        }
                }
                
            }
            
        }
        .padding()
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






