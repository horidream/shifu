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
    
    func on(_ notification: String, target:AnyObject? = nil, perform block: @escaping (Notification)->Void) ->some View {
        return self.onReceive(NotificationCenter.default.publisher(for: notification.toNotificationName(), object: target)) { notification in
            block(notification)
        }
    }
    
    func on(_ notification: Notification.Name, _ block:@escaping (Notification)->Void) ->some View {
        return self.onReceive(NotificationCenter.default.publisher(for: notification, object: nil)) { notification in
            block(notification)
        }
    }
    
    func snapshot(width: CGFloat = UIScreen.main.bounds.size.width, height: CGFloat = UIScreen.main.bounds.size.height) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width, height)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension Text: HasEmptyView {
    static public var emptyView: Self{
        return Text("")
    }
}

extension Image: HasEmptyView {
    static public var emptyView: Self{
        return Image(uiImage: UIImage())
    }
}



public extension View where Self: HasEmptyView{
    func when(_ condition: Bool) -> Self {
        if condition {
            return self
        } else {
            return Self.emptyView
        }
    }
    
    
}

public protocol HasEmptyView {
    static var emptyView:Self { get }
}

