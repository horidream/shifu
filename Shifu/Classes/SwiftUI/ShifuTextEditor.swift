//
//  ShifuTextEditor.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/19.
//

import SwiftUI

public struct ShifuTextEditor: UIViewRepresentable {
    struct HistoryItem: Equatable{
        let id:UUID = UUID()
        let text:String?
        let selection:NSRange?
    }
    
    public class History:ObservableObject{
        weak var delegate: ViewModel?
        var stack:[HistoryItem] = [HistoryItem(text: "", selection: nil)]
        public var cursor: Int = 0{
            didSet{
                objectWillChange.send();
            }
        }
        
        var canMoveBackward:Bool{
            return cursor > 0
        }
        
        var canMoveForward:Bool{
            return cursor < stack.count
        }
        
        func push(_ history: HistoryItem){
            stack = Array(stack[0...cursor])
            stack.append(history)
            cursor = stack.count - 1
        }
        
        func cursor(offset:Int){
            cursor += offset
        }
        
        func getHistory(_ offset: Int)-> HistoryItem?{
            let idx = cursor + offset
            return idx >= 0 ? stack.get(idx) : nil
        }
        
        var current:HistoryItem?{
            return stack.get(cursor)
        }
    }
    
    public class ViewModel: ObservableObject{
        @Published public var text:String = ""
        public var history = History()
        public var delegate: UITextView?
        public var inputAccessoryItems:[UIBarButtonItem] = []
        public init(){
            history.delegate = self
        }
        public init(builder: (ViewModel)->Void){
            builder(self)
        }
        
        private func update(history: HistoryItem){
            if let tv = self.delegate{
                text = history.text ?? ""
                if let selection = history.selection{
                    tv.selectedRange = selection
                }
                self.history.cursor = self.history.stack.index(of: history) ?? 0
            }
        }
        
        @discardableResult public func go(_ offset:Int)->Bool{
            if let item = history.getHistory(offset){
                update(history: item)
                return true
            }
            return false
        }
        
        @discardableResult public func hasHistory(_ offset:Int)->Bool{
            return history.getHistory(offset) != nil
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
                delay(0.03){
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
        textView.autocapitalizationType = .none
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if(uiView.text != viewModel.text){
            uiView.text = viewModel.text
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
//        @Binding var text: String
        var viewModel:ShifuTextEditor.ViewModel
        init(viewModel: ShifuTextEditor.ViewModel) {
            self.viewModel = viewModel
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            // UIKit -> SwiftUI
            viewModel.text = textView.text
            viewModel.history.push(HistoryItem(text: textView.text, selection: textView.selectedRange))
        }
    }
}
