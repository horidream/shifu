//
//  StickView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/6/30.
//

import SwiftUI

public struct StickyIcon: View{
    @State  private var threshold: Double = 0.5
    @State  private var previousThreshold: Double = 0.5
    @State  private var targetThreshold: Double = 0.5
    
    @State private var thresholdTween: TweenValue?
    @State private var radiusTween: TweenValue?

    @State  private var radius: Double = 0
    @State  private var targetRadius: Double = 0
    
    @Binding private var image:Icons.Name
    @Binding private var color:Color
    @State private var currentColor:Color

    @State private var targetImage = Icons.Name.swift_fa
    @State private var maxRadius: Double = 40
    private let delayTimeToShowAnimationIn:TimeInterval
    private var drawableImage: Image {
        if(targetImage.isFontAwesome){
            return Image(uiImage: Icons.uiImage(targetImage, size: 300))
        }else{
            return Image(targetImage)
        }
        
    }
    
    public init(image: Binding<Icons.Name>, color: Binding<Color> = .constant(.black), maxRadius: Double = 40, delay: TimeInterval = 0.3) {
        _image = image
        _color = color
        _currentColor = State(wrappedValue: color.wrappedValue)
        _maxRadius = State(wrappedValue: maxRadius)
        delayTimeToShowAnimationIn = delay
    }
    
    public var body: some View {
            currentColor.mask {
                Canvas { ctx, size in
                    ctx.addFilter(.alphaThreshold(min: threshold))
                    ctx.addFilter(.blur(radius: radius))
                    let w = size.width * 0.8
                    let originalSize = Icons.uiImage(targetImage).size
                    let h = w * originalSize.height / originalSize.width
                    let offsetX = (size.width - w) / 2
                    let offsetY = (size.height - h) / 2
                    let rect = CGRect(offsetX, offsetY, w, h)
                    ctx.draw(drawableImage, in: rect)
                }
            }
        .onChange(of: image, perform: { newValue in
            let timestamp = Date().timeIntervalSince1970
            thresholdTween = TweenValue(startTime: timestamp, endTime: timestamp + 0.4, start: threshold, end: 0.4, easing: { pow($0 , 3) })
            targetRadius = maxRadius
            previousThreshold = threshold
            targetThreshold = 0.4
            delay(delayTimeToShowAnimationIn){
                let timestamp = Date().timeIntervalSince1970
                thresholdTween = TweenValue(startTime: timestamp, endTime: timestamp + 0.4, start: threshold, end: 0.1, easing: { 1 - pow(1 - $0, 3 ) })
                targetImage = image
                targetRadius = 0
                previousThreshold = threshold
                targetThreshold = 0.1
            }
        })
        .onChange(of: color, perform: { newValue in
            ta($currentColor).to(newValue, duration: 0.6)
        })
        .onEnterFrame(isActive: targetRadius != radius || targetThreshold != threshold){ f in
            if targetRadius != radius {
                radius += (targetRadius - radius) * 0.15
            }
            
            if targetThreshold != threshold{
                if let thresholdTween = thresholdTween {
                    let timestamp = Date().timeIntervalSince1970
                    threshold = thresholdTween.valueForTime(timestamp)
                }
            }
            if( (targetRadius - radius) / (targetRadius - previousThreshold) < 0.01){
                radius = targetRadius
                threshold = targetThreshold
            }
        }
    }
}

struct TweenValue{
    var startTime: TimeInterval
    var duration:TimeInterval {
        endTime - startTime
    }
    var endTime: TimeInterval
    var start:Double
    var end: Double
    var offset:Double {
        end - start
    }
    var easing: (Double)->Double
    func progress(_ t:TimeInterval)->Double {
        max(0, min(1, (t - start) / (end - start)))
    }
    func valueForTime(_ t:TimeInterval)->Double{
        start + offset * easing(progress(t))
    }
    
    init(startTime: TimeInterval, endTime: TimeInterval, start: Double, end: Double, easing: @escaping (Double) -> Double) {
        self.startTime = startTime
        self.endTime = endTime
        self.start = start
        self.end = end
        self.easing = easing
    }
}
