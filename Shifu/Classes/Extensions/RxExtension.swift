//
//  RXExtension.swift
//  FMDB
//
//  Created by Baoli Zhai on 2020/4/12.
//

import UIKit
import RxSwift
import RxCocoa

protocol Optionable {
    associatedtype Wrapped
    func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
}

extension Optional: Optionable {}

extension ObservableType {
    func unwrap<R: Optionable>(_ transform: @escaping ((Element) -> R)) -> Observable<R.Wrapped> {
        return flatMap { (element: Element) -> Observable<R.Wrapped> in
            transform(element).flatMap(Observable.just) ?? Observable.empty()
        }
    }
}



extension CADisplayLink {
    public static let maximumFps = 60
}

public extension Reactive where Base: CADisplayLink {
    /**
     Link to the Display.
     - Parameter runloop: It can choose RunLoop to link for display. Default is main.
     - Parameter mode: The RunLoopMode has several modes. Default is commonModes. For details about RunLoopMode, see the [documents](https://developer.apple.com/reference/foundation/runloopmode).
     - Parameter fps: Frames per second. Default and max are 60.
     - Returns: Observable of CADisplayLink.
     */
    static func link(to runloop: RunLoop = .main, forMode mode: RunLoop.Mode = .common, fps: Int = Base.maximumFps) -> Observable<CADisplayLink> {
        return RxDisplayLink(to: runloop, forMode: mode, fps: fps).asObservable()
    }
}

public final class RxDisplayLink: ObservableType {
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, RxDisplayLink.Element == Observer.Element {
        var displayLink: Element? = Element(target: self, selector: #selector(displayLinkHandler))
        displayLink?.add(to: runloop, forMode: mode)
        if #available(iOS 10.0, tvOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = fps
        } else {
            displayLink?.frameInterval = max(Element.maximumFps / fps, 1)
        }
        
        self.observer = AnyObserver<Element>(observer)
        
        return Disposables.create {
            self.observer = nil
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    public typealias Element = CADisplayLink
    private let runloop: RunLoop
    private let mode: RunLoop.Mode
    private let fps: Int
    private var observer: AnyObserver<Element>?
    
    @objc dynamic private func displayLinkHandler(link: Element) {
        observer?.onNext(link)
    }
    
    public init(to runloop: RunLoop, forMode mode: RunLoop.Mode, fps: Int) {
        self.runloop = runloop
        self.mode = mode
        self.fps = fps
    }
}
