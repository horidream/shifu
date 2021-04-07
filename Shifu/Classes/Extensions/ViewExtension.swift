//
//  ViewExtension.swift
//  ClipboardComposer
//
//  Created by Baoli Zhai on 2021/2/4.
//

import SwiftUI
import Combine


@available(iOS 13.0, *)
public extension View {
    func log(_ items:Any...)-> some View {
        print(items.map{ "\($0)" }.joined(separator: ", ") )
        return self
    }

    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content, else otherContent: ((Self)-> Content)? = nil) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            if let otherContent = otherContent{
                return AnyView(otherContent(self))
            }else{
                return AnyView(self)
            }
        }
    }
    
    @ViewBuilder func `if2`<Content: View>(_ conditional: Bool, content: (Self) -> Content, else otherContent: ((Self)-> Content)? = nil) -> some View {
        if conditional {
            content(self)
        } else {
            if let otherContent = otherContent{
                otherContent(self)
            }else{
                self
            }
        }
    }
    
    func perform(_ block:(Self)->Void) -> Self {
        block(self)
        return self
    }
}


