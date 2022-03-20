//
//  ShifuTextEditor.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/19.
//

import SwiftUI

public struct ShifuTextEditor: UIViewRepresentable {
    public class ViewModel: ObservableObject{
        @Published public var text:String = ""
        public var delegate: UITextView?
        public var inputAccessoryItems:[UIBarButtonItem] = []
        public init(){}
        public init(builder: (ViewModel)->Void){
            builder(self)
        }
        
        public func update(text:String){
            if let tv = self.delegate{
                tv.text = text
                tv.delegate?.textViewDidChange?(tv)
            }
        }
        
        public func modifySelection(modifier:(String)->(string: String, selectioOffset: Int)){
            if let txt = delegate?.text, let selectedRange = delegate?.selectedRange{
                let p1 = txt.substring(0, selectedRange.lowerBound)
                let p2 = txt.substring(selectedRange.lowerBound, selectedRange.upperBound)
                let p3 = txt.substr(selectedRange.upperBound)
                let modified = modifier(p2)
                update(text:  p1 + modified.string + p3)
                delay(0.01){
                    let r = NSMakeRange(p1.count + modified.selectioOffset, 0)
                    self.delegate?.selectedRange = r
                    self.delegate?.scrollRangeToVisible(r)
                }
            }
        }
    }
    
    let textView = UITextView()
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel){
        self.viewModel = viewModel
    }
    public func makeUIView(context: Context) -> UITextView {
        textView.delegate = context.coordinator
        viewModel.delegate = textView
        
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width: textView.frame.size.width, height: 50))
        toolbar.items = viewModel.inputAccessoryItems
        textView.inputAccessoryView = toolbar
        
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if(uiView.text != viewModel.text){
            uiView.text = viewModel.text
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(text: $viewModel.text)
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            // UIKit -> SwiftUI
            _text.wrappedValue = textView.text
        }
//        
//        public func textViewDidChangeSelection(_ textView: UITextView) {
//            _text.wrappedValue = textView.text
//        }
    }
}
