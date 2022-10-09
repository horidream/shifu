//
//  ShifuPasteButton.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/9/19.
//

import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers

public struct ShifuPasteButton<T: View>: View {
    @Binding var shouldCompress:Bool
    let onPaste:([NSItemProvider])->Void
    let builder: ()-> T
    public init(@ViewBuilder view builder: @escaping ()-> T, onPaste: @escaping ([NSItemProvider])->Void, shouldCompress: Binding<Bool> = .constant(false) ){
        self.onPaste = onPaste
        self.builder = builder
        self._shouldCompress = shouldCompress
    }
    public var body: some View{
        if #available(iOS 16, *){
            HackedPasteButton()
        }else {
            TranditionalBtn()
        }
    }
    
    func TranditionalBtn()-> some View{
        builder().onTapGesture{
            onPaste(pb.itemProviders)
        }
    }
    

    
    @available(iOS 16, *)
    func HackedPasteButton()-> some View {
        return
            PasteButton(supportedContentTypes: [.data]) { items in
                if shouldCompress {
                    pb.items = pb.items
                }
                onPaste(items)
            }
            .labelStyle(.iconOnly)

    }
}
