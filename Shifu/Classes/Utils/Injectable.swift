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
        if self.responds(to:Selector("layoutViews:")){
            NotificationCenter.default.addObserver(self, selector: Selector("layoutViews:"), name: NSNotification.Name("INJECTION_BUNDLE_NOTIFICATION"), object: nil)
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


private var isBundleLoaded = false
private var loadInjection: () = {
#if DEBUG
    guard !isBundleLoaded else { return }
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
            isBundleLoaded = true
        }else {
            debugPrint("Injection注入失败,未能检测到Injection")
        }
    } catch {
        debugPrint("Injection注入失败\(error)")
    }
    #endif
}()



public let injectionObserver = InjectionObserver()
let observedInjectionObserver = ObservedObject(wrappedValue: injectionObserver)
public class InjectionObserver: ObservableObject {
    @Published var injectionNumber = 0
    var cancellable: AnyCancellable? = nil
    let publisher = PassthroughSubject<Void, Never>()
    init() {
        cancellable = NotificationCenter.default.publisher(for:
                                                                Notification.Name("INJECTION_BUNDLE_NOTIFICATION"))
            .sink { [weak self] change in
                self?.injectionNumber += 1
                self?.publisher.send()
            }
    }
    
}



extension View {

    public var _iO:ObservedObject<InjectionObserver> {
        return observedInjectionObserver
    }
    public func eraseToAnyView() -> some View {
        _ = loadInjection
        return AnyView(self)
    }
    public func onInjection(bumpState: @escaping () -> ()) -> some View {
        return self
        #if DEBUG
            .onReceive(injectionObserver.publisher, perform: bumpState)
            .eraseToAnyView()
            .when(_iO.wrappedValue.injectionNumber >= 0)
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



