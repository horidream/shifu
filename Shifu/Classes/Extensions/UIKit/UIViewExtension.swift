//
//  UIViewExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/3/28.
//

import UIKit
import WebKit
import CoreServices

@available(iOS 9.0, *)
public extension UIView{
    public struct LayoutPosition: OptionSet{
        public let rawValue: Int
        public init(rawValue: Int){
            self.rawValue = rawValue
        }
        public static let top   = LayoutPosition(rawValue: 1 << 0)
        public static let right   = LayoutPosition(rawValue: 1 << 1)
        public static let bottom   = LayoutPosition(rawValue: 1 << 2)
        public static let left   = LayoutPosition(rawValue: 1 << 3)
        public static let all:LayoutPosition   = [.top, .right, .bottom, .left]


    }
    /// The margin of top, right, bottom, left,  same as css.
    @discardableResult func quickMargin(_ top: CGFloat? = 0, _ rest:CGFloat?..., reference:UIView? = nil)->Self{
        var right:CGFloat?, bottom:CGFloat?, left: CGFloat?
        switch rest.count {
        case 0:
            right = top
            left = top
            bottom = top
        case 1:
            bottom = top
            left = rest[0]
            right = rest[0]
        case 2:
            bottom = rest[1]
            left = rest[0]
            right = rest[0]
        case 3...:
            right = rest[0]
            bottom = rest[1]
            left = rest[2]
        default:()
        }
        if let parent = reference ?? self.superview{
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                top == nil ? nil : self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: top!),
                right == nil ? nil : self.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor, constant: -right!),
                bottom == nil ? nil : self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -bottom!),
                left == nil ? nil : self.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor, constant: left!),
            ].compactMap{
                $0?.priority = .defaultHigh
                return $0
            })
        }
        return self
    }
    
    /// width, height
    @discardableResult func quickSize(_ width: CGFloat? = nil, _ height: CGFloat? = nil)->Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            width == nil ? nil : self.widthAnchor.constraint(equalToConstant: width!),
            height == nil ?  nil : self.heightAnchor.constraint(equalToConstant: height!)
        ].compactMap{ $0 })
        return self
    }
    
    /// position the view with as digital input
    @discardableResult func quickAlign(_ type:UInt = 5, _ offsetX:CGFloat = 0, _ offsetY:CGFloat = 0, _ reference:UIView? = nil)->Self{
        if let parent = reference ?? self.superview{
            self.translatesAutoresizingMaskIntoConstraints = false
            switch type {
            case 1:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 2:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerXAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 3:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor, constant: offsetX),
                    self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 4:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerYAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 5:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerXAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerYAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 6:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor, constant: offsetX),
                    self.centerYAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerYAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 7:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 8:
                NSLayoutConstraint.activate([
                    self.centerXAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerXAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 9:
                NSLayoutConstraint.activate([
                    self.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor, constant: offsetX),
                    self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
            case 0:
                NSLayoutConstraint.activate([
                    self.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor, constant: offsetX),
                    self.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor, constant: -offsetX),
                    self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: offsetY),
                    self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -offsetY)
                ].map{
                    $0.priority = .defaultLow
                    return $0
                })
                
            default:()
                
            }
        }
        return self
    }
    
    
    
    @discardableResult func add(to superView: UIView?)->Self{
        superView?.addSubview(self)
        return self
    }
    
    @discardableResult func addBorder(position: LayoutPosition = .bottom,  color: UIColor = UIColor.red, margin: CGFloat = 0, lineWidth: CGFloat = 1) -> UIView{
        func borderView()->UIView{
            let border = UIView()
            border.backgroundColor = color
            self.addSubview(border)
            return border
        }
        if position.contains(.left){
            borderView().quickSize(lineWidth, nil ).quickMargin(margin, nil, margin, 0)
        }
        if position.contains(.right){
            borderView().quickSize(lineWidth, nil ).quickMargin(margin, 0, margin, nil)
        }
        if position.contains(.top){
            borderView().quickSize(nil, lineWidth ).quickMargin(0, margin, nil , margin)
        }
        if position.contains(.bottom){
            borderView().quickSize(nil, lineWidth ).quickMargin(nil, margin, 0 , margin)
        }
        return self
    }
    
    func blink(duration:TimeInterval = 2, count: Int = 3, delay:TimeInterval = 0 ){
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)], animations: {
            let step = count * 2
            let relativePiece:Double = 1 / Double(step)
            for i in (0..<step){
                UIView.addKeyframe(withRelativeStartTime: Double(i) * relativePiece, relativeDuration:  relativePiece) {
                    self.alpha = i % 2 == 1 ? 1 : 0
                }
            }
        })
    }
    
}

public enum SnapshotTarget{
    case album, clipboard(SnapshotType), none
}
public enum SnapshotType{
    case png, jpg
}

public extension WKWebView{
    func snapshot(config: WKSnapshotConfiguration? = nil, target: SnapshotTarget = .clipboard(.jpg), callback: ((Any?)->Void)? = nil){
        self.takeSnapshot(with: config) { (image, error) in
            if let image = image{
                switch target{
                case .album:
                    image.writeToAlbum()
                case .clipboard(let type):
                    if type == .jpg{
                        UIPasteboard.general.setData(image.jpegData(compressionQuality: 0.5) ?? Data(), forPasteboardType: kUTTypeJPEG as String)
                    }else{
                        UIPasteboard.general.setData(image.pngData() ?? Data(), forPasteboardType: kUTTypePNG as String)
                    }
                default:()
                }
                callback?(image)
            } else {
                callback?(nil)
            }
        }
    }
    
}

public extension UIViewController{
    func add(_ viewController:UIViewController){
        view.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

    func remove(){
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
