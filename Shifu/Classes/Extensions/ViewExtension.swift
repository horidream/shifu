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
    
    func when(_ condition: Bool) -> some View {
        if condition {
            return AnyView(self)
        } else {
            return AnyView(EmptyView())
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

extension Text: HasEmptyView {
    public var emptyView: Self{
        return Text("")
    }
}

extension Image: HasEmptyView {
    public var emptyView: Self{
        return Image(uiImage: UIImage())
    }
}



public extension View where Self: HasEmptyView{
    func when(_ condition: Bool) -> Self {
        if condition {
            return self
        } else {
            return emptyView
        }
    }
}

public protocol HasEmptyView {
    var emptyView:Self { get }
}

