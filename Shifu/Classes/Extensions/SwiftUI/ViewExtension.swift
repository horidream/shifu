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
    
    func padding(_ top: CGFloat, _ rest:CGFloat...)->some View{
        let edges = [top] + rest
        switch edges.count{
        case 1:
            return self.padding(EdgeInsets(top: edges[0], leading: edges[0], bottom: edges[0], trailing: edges[0]))
        case 2:
            return self.padding(EdgeInsets(top: edges[0], leading: edges[1], bottom: edges[0], trailing: edges[1]))
        case 3:
            return self.padding(EdgeInsets(top: edges[0], leading: edges[1], bottom: edges[2], trailing: edges[1]))
        default:
            return self.padding(EdgeInsets(top: edges[0], leading: edges[3], bottom: edges[2], trailing: edges[1]))
        }
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
    
    
    
    @ViewBuilder
    func `if2`<Content: View>(_ conditional: Bool, content: (Self) -> Content, else otherContent: ((Self)-> Content)? = nil) -> some View {
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
    
    func snapshot(_ rect: CGRect? = nil, backgroundColor: UIColor? = nil) -> UIImage {
        let controller = UIHostingController(rootView: self.ignoresSafeArea(.all))
        let view = controller.view
        let targetSize = rect?.size ?? controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: rect?.origin ?? .zero, size: targetSize)
        view?.backgroundColor = backgroundColor ?? .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func onTapTarget(_ callback: @escaping (Self)->Void)->some View{
        return self.onTapGesture {
            callback(self)
        }
    }
    
    var _rootViewController: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
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
    public func when(_ condition: Bool) -> Self {
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


public extension Color{
    static var random:Color{
        return Color(red: Double.random(in: 0...255)/255, green: Double.random(in: 0...255)/255, blue: Double.random(in: 0...255)/255)
    }
    
    init(_ hexValue:UInt, alpha:CGFloat = 1.0){
        self.init(UIColor(hexValue, alpha: alpha).cgColor)
    }
}

// MARK: - computed properties
public extension View{
    var safeArea:UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .init()
        }
        return safeArea
    }
}
