//
//  Injectable.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/1/29.
//

import Foundation
import SwiftUI
import Combine

public protocol Injectable{ }

public extension Injectable where Self: NSObjectProtocol{
    func startInjection(){
#if DEBUG
        if self.responds(to:Selector(("layoutViews:"))){
            NotificationCenter.default.addObserver(self, selector: Selector(("layoutViews:")), name: NSNotification.Name("INJECTION_BUNDLE_NOTIFICATION"), object: nil)
        }
#endif
    }
    
}

fileprivate var internalInected = NotificationCenter.default
    .publisher(for: NSNotification.Name("INJECTION_BUNDLE_NOTIFICATION"))
public extension Injectable where Self: View{
    var injected:NotificationCenter.Publisher  {
        return internalInected
    }
}


private var loadInjection: () = {
#if DEBUG
    do {
#if os(macOS)
        let bundleName = "macOSInjection.bundle"
#elseif os(tvOS)
        let bundleName = "tvOSInjection.bundle"
#elseif targetEnvironment(simulator)
        let bundleName = "iOSInjection.bundle"
#else
        let bundleName = "maciOSInjection.bundle"
#endif
        let injectionBundle = Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/"+bundleName)
        if let bundle = injectionBundle {
            try bundle.loadAndReturnError()
        }else {
            debugPrint("Injection注入失败,未能检测到Injection")
        }
    } catch {
        debugPrint("Injection注入失败\(error)")
    }
    #endif
}()



let _injectionObserver = InjectionObserver()
//let observedInjectionObserver = ObservedObject(wrappedValue: _injectionObserver)
public class InjectionObserver: ObservableObject {
    @Published public var injectionCount = 0
    var cancellable: AnyCancellable? = nil
    let publisher = PassthroughSubject<Void, Never>()
    init() {
        cancellable = NotificationCenter.default.publisher(for:
                                                                Notification.Name("INJECTION_BUNDLE_NOTIFICATION"))
            .sink { [weak self] change in
                self?.injectionCount += 1
                self?.publisher.send()
            }
    }
    
}



extension View {
    public static var injectionObserver:InjectionObserver {
        _injectionObserver
    }
//    public var _iO:ObservedObject<InjectionObserver> {
//        return observedInjectionObserver
//    }
    public func eraseToAnyView() -> AnyView {
        if let currentView = self as? AnyView{
            print("is already AnyView")
            return currentView
        }
        return AnyView(self)
    }
    func ensureInjection()->Self{
        _ = loadInjection
        return self
    }
    public func onInjection(bumpState: @escaping () -> ()) -> some View {
        return self
        #if DEBUG
            .onReceive(_injectionObserver.publisher, perform: bumpState)
            .ensureInjection()
            .when(_injectionObserver.injectionCount >= 0)
        #endif
    }
}





public extension UIApplicationDelegate{
    func initInjection(){
#if DEBUG
        do {
#if os(macOS)
            let bundleName = "macOSInjection.bundle"
#elseif os(tvOS)
            let bundleName = "tvOSInjection.bundle"
#elseif targetEnvironment(simulator)
            let bundleName = "iOSInjection.bundle"
#else
            let bundleName = "maciOSInjection.bundle"
#endif
            let injectionBundle = Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/"+bundleName)
            if let bundle = injectionBundle {
                try bundle.loadAndReturnError()
            }else {
                debugPrint("Injection注入失败,未能检测到Injection")
            }
        } catch {
            debugPrint("Injection注入失败\(error)")
        }
#endif
    }
}



