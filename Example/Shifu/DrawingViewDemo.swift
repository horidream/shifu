//
//  DrawingViewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/10/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Combine
import Shifu
import PencilKit

struct DrawingViewDemo: View {
    @State var canvas: PKCanvasView = with(PKCanvasView()){
        $0.drawingPolicy = .anyInput
        $0.tool = PKInkingTool(.marker, color: .red, width: 15)
    }
    var body: some View {
        DrawingView(canvas)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    Button{
                        let img = canvas.drawing.image(from: canvas.bounds, scale: 0)
                        pb.image = img
                        
                    } label: {
                        Image.resizableIcon(.squareAndArrowDown, size: 18)
                    }
                }
            }
    }
}

struct DrawingViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        DrawingViewDemo()
    }
}
