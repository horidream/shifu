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
    public class Config: UIWrapperConfig {
        @Published var shouldCompress = false
    }
    let onPaste:([NSItemProvider])->Void
    let builder: ()-> T
    let supportedContentType:[UTType]
    @StateObject var config = Config()
    public init(supportedContentType: [UTType] = [.data], @ViewBuilder view builder: @escaping ()-> T, onPaste: @escaping ([NSItemProvider])->Void, config customizeConfig: ((Config)->Void)? = nil){
        self.onPaste = onPaste
        self.builder = builder
        self.supportedContentType = supportedContentType
        customizeConfig?(self.config)
    }
    
    public var body: some View{
        HackedPasteButton()
    }
    
    func TranditionalBtn()-> Button<T>{
        Button{
            onPaste(pb.itemProviders)
        } label: {
            builder()
        }
    }
    

    @ViewBuilder
    func HackedPasteButton()-> some View {
        if #available(iOS 16, *){
            if config.forceLegacy {
                TranditionalBtn()
            } else {
                PasteButton(supportedContentTypes: supportedContentType) { items in
                    if config.shouldCompress {
                        pb.items = pb.items
                    }
                    onPaste(items)
                }
                .labelStyle(.iconOnly)
            }
        }else {
            TranditionalBtn()
        }

    }
}


public class UIWrapperConfig:ObservableObject {
    @Published public var forceLegacy: Bool = false
}
