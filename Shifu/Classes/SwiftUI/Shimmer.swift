//
//  ShimmerViewModifier.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/5/9.
//

import SwiftUI

public struct Shimmer:ViewModifier{
    public init(){}
    @State var animation = false
    @State var color:Color = .random
    public func body(content: Content) -> some View {
        
        ZStack{
            content
                .foregroundColor(.white.opacity(0.25))
            content
                .foregroundColor(color)
                .blendMode(.lighten)
                .mask {
                    GeometryReader{ proxy in
                        let w = proxy.size.width
                        let h = proxy.size.height
                        Rectangle()
                            .fill(LinearGradient(gradient: .init(colors: [.white.opacity(0.1), .white, .white.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                            .frame(height: min(50, proxy.size.height))
                            .rotationEffect(.degrees(90))
                            .offset(x: -w/2 - h/2)
                            .offset(x: animation ? w + h/2 : 0)
                    }
                }
        }
        .frame(alignment: .center)
        .onAppear{
            Timer.publish(every: 2, on: .current, in: .common)
                .autoconnect()
                .prepend(Date())
                .delay(for: .seconds(0), scheduler: RunLoop.main, options: .none)
                .sink { _ in
                    ta($animation).from(false, to: true, duration: 2)
                    ta($color).to(.random, duration: 2)
                }
                .retain()
        }
        .eraseToAnyView()
    }
}
