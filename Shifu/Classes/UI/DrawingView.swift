//
//  DrawingView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/23.
//

import SwiftUI
import PencilKit

public struct DrawingView: View {
    private(set) var canvasView:PKCanvasView
    public init(_ canvasView: PKCanvasView = PKCanvasView()) {
        self.canvasView = canvasView
    }
    public var body: some View {
        MyCanvas(canvasView: canvasView)
    }
}

struct MyCanvas: UIViewRepresentable {
    var canvasView: PKCanvasView
    let picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
//        self.canvasView.tool = PKInkingTool(.marker, color: .red, width: 15)
        self.canvasView.delegate = context.coordinator
        self.canvasView.becomeFirstResponder()
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate{
        
    }
     
}
